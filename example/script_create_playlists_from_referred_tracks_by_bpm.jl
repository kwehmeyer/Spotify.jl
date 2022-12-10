using Spotify
using Spotify.Playlists
using Spotify.Tracks
const batchsize = 50 # max
# My very slowest jogging pace
const minBPM = 63 
# More than double the beat is meaningless. 
const maxBPM = minBPM * 2 - 1
# From experience, felt pace for a good playlist
const deltaBPM = 2

########################################
# Collect the playlists created by user.
########################################
playlists = Vector{SpPlaylistId}()
playlistnames = Vector{String}()
for batchno = 0:200
    offset = batchno * batchsize
    json, waitsec = playlist_get_current_user(limit = batchsize, offset = batchno * batchsize)
    waitsec > 0 && throw("Too fast, whoa!")
    l = length(json.items)
    l == 0 && break
    for item in json.items
        if item.owner.display_name == string(SpUserId())
            println(item.name)
            push!(playlists, SpPlaylistId(item.id))
            push!(playlistnames, item.name)
        else
            @show item.owner
        end
    end
end
###############################################################
# Make a set of the unique tracks contained in those playlists.
###############################################################
track_set = Set{Tuple{SpId, String}}()
for (playlistid, playlistname) in zip(playlists, playlistnames)
    @show playlistname
    for batchno = 0:1000
        offset = batchno * batchsize
        json, waitsec = playlist_get_tracks(playlistid, limit = batchsize, offset = batchno * batchsize)
        waitsec > 0 && throw("Too fast, whoa!")
        l = length(json.items)
        l == 0 && break
        for item in json.items
            if item.track.id !== nothing # Some are no longer available
                push!(track_set, (SpId(item.track.id), item.track.name))
            end
        end
        println("")
    end
end
track_collection = collect(track_set)
n = length(track_collection)

####################################################################################
# Order the tracks by categories or buckets. Each bucket will become a new playlist.
####################################################################################

bucketmin = [i for i in minBPM:deltaBPM:maxBPM]
bucketmax = [i+deltaBPM - 1 for i in minBPM:deltaBPM:maxBPM]
# There are so many public playlist with 'bpm' in the name, we go for 'spm' instead,
# meaning 'strokes per minute'.
bucketnames = ["$mi-$(ma)spm" for (mi, ma) in zip(bucketmin, bucketmax)]
Idbucket = Vector{SpId}
Namebucket = Vector{String}
tracknamebuckets = Vector{Namebucket}()
idbuckets = Vector{Idbucket}()
for i = 1:length(bucketnames)
    # Oh so inelegant, but fill would make every element refer to the same object
    push!(tracknamebuckets, Namebucket())
    push!(idbuckets, Idbucket())
end
i = 0

for (trackid, trackname) in track_collection
    af, waitsec =  tracks_get_audio_features(trackid)
    waitsec > 0 && throw("Too fast, whoa!")
    # There's a lot of audio features! We use one.
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-audio-features
    tempo = af.tempo
    while tempo >= maxBPM
        tempo /= 2
    end
    while tempo < minBPM
        tempo *= 2
    end
    tempo = min(tempo, maxBPM)
    bucketno = findfirst(x-> x >= tempo, bucketmin)
    i += 1
    printstyled(round(i / n, digits = 3), " Tempo: $(round(tempo, digits=0)),  Bucket no.: $bucketno   $trackname \n", color=:176)
    push!(tracknamebuckets[bucketno], trackname)
    push!(idbuckets[bucketno], trackid)
end
# Inspect what we got in our buckets
for bucketno in 1:length(bucketnames)
    println(rpad(bucketnames[bucketno], 25), "No. of tracks: ", length(idbuckets[bucketno]))
end
# That was fine, but we risk that some buckets are empty.
#####################################################
# Create additional playlists (for non-empty buckets)
#####################################################
for (bucket_list_name, tracknamebucket, trackidbucket) in zip(bucketnames, tracknamebuckets, idbuckets)
    if length(tracknamebucket) > 1
        @show bucket_list_name
        # Use existing playlistname if it exists
        existingno = findfirst(x -> x == bucket_list_name, playlistnames)
        if existingno !== nothing
            playlistid = playlists[existingno]
        else
            # Create a new playlist
            json, waitsec = playlist_create_playlist(bucket_list_name, public = false)
            playlistid  = SpPlaylistId(json.id)
            # Add it to the in-memory store
            push!(playlists, playlistid)
            push!(playlistnames, bucket_list_name)
        end
        # Check that the tracklist is actually empty (we don't want to duplicate tracks)
        json, waitsec = playlist_get_tracks(playlistid)
        waitsec > 0 && throw("Too fast, whoa!")
        l = length(json.items)
        if l == 0
            # Now fill this playlist with what's in trackidbucket
            display(playlistid)
            display(trackidbucket)
            playlist_add_tracks_to_playlist(playlistid, trackidbucket)
        else
            @warn "Beware, we were almost going to add tracks to non-empty playlist $bucket_list_name"
        end
    end
end