using Spotify
using Spotify.Playlists
using Spotify.Tracks
LOGSTATE.request_string = false
LOGSTATE.authorization = false
const batchsize = 50 # max
# My very slowest jogging pace
const minBPM = 63 
# More than double the beat is meaningless. 
const maxBPM = minBPM * 2 - 1
# From experience, pace deviation 
# which feels identical.
const deltaBPM = 2

########################################
# Collect the playlists created by user.
########################################
playlists = Vector{SpPlaylistId}()
playlistnames = Vector{String}()
for batchno = 0:200
    offset = batchno * batchsize
    json, waitsec = playlist_get_current_user(limit = batchsize, offset = batchno * batchsize)
    isempty(json) && break
    waitsec > 0 && throw("Too fast, whoa!")
    l = length(json.items)
    l == 0 && break
    for item in json.items
        if item.owner.display_name == string(SpUserId())
            println(item.name)
            push!(playlists, SpPlaylistId(item.id))
            push!(playlistnames, item.name)
        else
            printstyled("We're not including $(item.name), which is owned by $(item.owner.id)\n", color= :176)
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
printstyled("$n unique tracks identified from 'playlistnames'\n", color= :176)


######################################################################################
# Order the tracks by categories or buckets. Each bucket is intended for new playlist.
######################################################################################

bucketmin = [i for i in minBPM:deltaBPM:maxBPM]
bucketmax = [i+deltaBPM - 1 for i in minBPM:deltaBPM:maxBPM]
# There are so many public playlist with 'bpm' in the name, we go for 'spm' instead,
# meaning 'strokes per minute'.
bucketnames = ["$mi-$(ma)spm" for (mi, ma) in zip(bucketmin, bucketmax)]

# Prepare some containers we'll need
Idbucket = Vector{SpId}
Namebucket = Vector{String}
tracknamebuckets = Vector{Namebucket}()
idbuckets = Vector{Idbucket}()
for i = 1:length(bucketnames)
    # Oh so inelegant, but `fill`` would make every element refer to the same object
    push!(tracknamebuckets, Namebucket())
    push!(idbuckets, Idbucket())
end

# Now loop through track_collection, ask Spotify for the tempo, and drop in the right container.
# Expect some temporary holdups since we're making a potentially large number of requests.
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
    printstyled(rpad(round(i / n, digits = 3), 10), 
        rpad(" Tempo: $(round(tempo, digits = 0))  Bucket no.: $bucketno ", 35), 
        "$trackname \n", color = :176)
    push!(tracknamebuckets[bucketno], trackname)
    push!(idbuckets[bucketno], trackid)
end
# Inspect what we got in our buckets
for bucketno in 1:length(bucketnames)
    println(rpad(bucketnames[bucketno], 25), "No. of tracks: ", length(idbuckets[bucketno]))
end

#####################################################
# Create additional playlists (for non-empty buckets)
#####################################################
for (bucket_list_name, tracknamebucket, trackidbucket) in zip(bucketnames, tracknamebuckets, idbuckets)
    if length(tracknamebucket) > 1 # Only create non-empty playlists
        @show bucket_list_name
        # Use existing playlistname if possible
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