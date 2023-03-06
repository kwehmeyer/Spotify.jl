# TODO: fix this: tempo 75.942 is assigned to 77-78 playlist.
using Spotify
using Spotify.Playlists
using Spotify.Tracks
const batchsize = 50 # max
# My very slowest jogging pace
const minBPM = 63 
# More than double the beat is meaningless. 
const maxBPM = minBPM * 2 - 1
# From experience, pace deviation 
# which feels identical.
const deltaBPM = 2

include("playlist_and_library_utilties.jl")
########################################
# Collect the playlists created by user.
########################################
playlist_ids, playlist_names = get_owned_playlist_ids_and_names(;silent=true);

#####################################################
# Collect all tracks contained in all those playlists
#####################################################

track_ids = SpTrackId[]
track_names = String[]
for (playlist_id, playlist_name) in zip(playlist_ids, playlist_names)
    playlist_description = "\"" * playlist_details_string(playlist_id) * " \""
    print("Collecting ")
    ts, ns  = track_ids_and_names_in_playlist(playlist_id)
    append!(track_ids, ts)
    append!(track_names, ns)
    println("$(length(ts)) tracks from $(playlist_description)")
end
clean_track_ids, clean_track_names = track_ids_and_names_cleaned_of_duplicates(track_ids, track_names)
n = length(track_ids) - length(clean_track_ids)

printstyled("$(length(clean_track_ids)) unique tracks identified, $n were duplicates\n", color= :176)

######################################################################################
# Order the tracks by categories or buckets. Each bucket is intended for new playlist.
######################################################################################

bucketmin = [i for i in minBPM:deltaBPM:maxBPM]
bucketmax = [i+deltaBPM - 1 for i in minBPM:deltaBPM:maxBPM]
# There are so many public playlist with 'bpm' in the name, we go for 'spm' instead,
# meaning 'strokes per minute'.
bucketnames = ["$mi-$(ma)spm" for (mi, ma) in zip(bucketmin, bucketmax)]

# Prepare some containers we'll need
Idbucket = Vector{SpTrackId}
Namebucket = Vector{String}
tracknamebuckets = Vector{Namebucket}()
idbuckets = Vector{Idbucket}()
for i = 1:length(bucketnames)
    # Oh so inelegant, but `fill`` would make every element refer to the same object
    push!(tracknamebuckets, Namebucket())
    push!(idbuckets, Idbucket())
end


################################################
# Loop through track_collection, ask Spotify for
# the tempo, drop track in the right container.
# No playlists are created yet.
################################################
trackno = 0
for (trackid, trackname) in zip(clean_track_ids, clean_track_names)
    af, waitsec =  tracks_get_audio_features(trackid)
    waitsec > 0 && throw("Too fast, unexpedet. Add sleep(waitsec)?")
    # There's a lot of audio features! We use one.
    tempo = af.tempo
    # We halve or double the tempo if outside normal pacing.
    while tempo >= maxBPM
        tempo /= 2
    end
    while tempo < minBPM
        tempo *= 2
    end
    tempo = min(tempo, maxBPM)
    bucketno = findfirst(x-> x > tempo, bucketmin) - 1
    trackno += 1
    printstyled(rpad(round(trackno / n, digits = 3), 10), 
        rpad(" Tempo: $(round(tempo, digits = 0))  Bucket no.: $bucketno ", 35), 
        "$trackname \n", color = :176)
    push!(tracknamebuckets[bucketno], trackname)
    push!(idbuckets[bucketno], trackid)
end
# Inspect what we got in our buckets
for bucketno in 1:length(bucketnames)
    println(rpad(bucketnames[bucketno], 25), "No. of tracks: ", length(idbuckets[bucketno]))
end

############################################################
# Create additional, empty playlists (for non-empty buckets)
############################################################
for (bucket_list_name, tracknamebucket, trackidbucket) in zip(bucketnames, tracknamebuckets, idbuckets)
    if length(tracknamebucket) > 1 # Only create non-empty playlists
        # Use existing playlistname if possible
        existingno = findfirst(x -> x == bucket_list_name, playlist_names)
        if existingno !== nothing
            playlist_id = playlist_ids[existingno]
        else
            # Create a new playlist
            println("Creating new playlist $(bucket_list_name)")
            json, waitsec = playlist_create_playlist(bucket_list_name, public = false)
            playlist_id  = SpPlaylistId(json.id)
            println("    Created  ", repr(playlist_id))
            # Add it to the in-memory store
            push!(playlist_ids, playlist_id)
            push!(playlist_names, bucket_list_name)
        end
    end
end
###########################################################################
# Fill the empty playlists. Don't add more tracks to playlists with content
###########################################################################
for (bucket_list_name, tracknamebucket, trackidbucket) in zip(bucketnames, tracknamebuckets, idbuckets)
    if length(tracknamebucket) > 1 
        existingno = findfirst(x -> x == bucket_list_name, playlist_names)
        playlist_id = playlist_ids[existingno]
        # Check that the tracklist is actually empty (we don't want to duplicate tracks)
        json, waitsec = playlist_get_tracks(playlist_id)
        waitsec > 0 && throw("Too fast, whoa! Unexpected, add sleep(waitsec)!")
        l = length(json.items)
        if l == 0
            # Now fill this playlist with what's in trackidbucket
            display(playlist_id)
            display(bucket_list_name)
            display(trackidbucket)
            playlist_add_tracks_to_playlist(playlist_id, trackidbucket)
        else
            @info "Not adding tracks to non-empty playlist $(bucket_list_name)"
        end
    end
end
