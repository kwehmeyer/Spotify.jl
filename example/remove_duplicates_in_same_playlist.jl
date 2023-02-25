# Remove duplicates in same playlist
#
# Use case 1: You suspect the same track appears twice, but
#             can't be bothered to check that in your long
#             playlists.
#
# We're rebuilding the affected playlists, so metadata like 'inserted when' is lost.
using Spotify, Spotify.Playlists
include("playlist_and_library_utilties.jl")

#####################################
# Collect the playlists owned by user
#####################################
playlist_ids, playlist_names = get_owned_playlist_ids_and_names(;silent=true);

#########################################################################
# For each playlist, look for duplicates and remove when permission given
#########################################################################
for (playlist_id, playlist_name) in zip(playlist_ids, playlist_names)
    playlist_description = "\"" * playlist_details_string(playlist_id) * " \""
    track_ids, track_names  = track_ids_and_names_in_playlist(playlist_id)
    clean_track_ids, clean_track_names = track_ids_and_names_cleaned_of_duplicates(track_ids, track_names)
    n = length(track_ids) - length(clean_track_ids)
    if n == 0
        printstyled("No duplicates in $playlist_description \n", color = :light_black)
    else
        println("$n duplicates in $playlist_description , out of  $(length(track_ids)):")
        duplrows = _find_duplicate_items(track_ids)
        superflous_track_ids = [t for (i, t) in enumerate(track_ids) if i ∈ duplrows] 
        superfluous_track_names = [n for (i, n) in enumerate(track_names) if i ∈ duplrows]
        M = hcat(superflous_track_ids, superfluous_track_names, duplrows)
        display(M)
        println("\nPress 'y + Return' to confirm, 'e + Return' to exit")
        kbinp = readline(stdin)
        if kbinp == "y"
            println("OK!!")
            playlist_remove_playlist_item(playlist_id, track_ids)
            sleep(2)
            println("Deleted all, don't quit while we're adding $(length(clean_track_ids)) tracks")
            playlist_add_tracks_to_playlist(playlist_id, clean_track_ids)
        elseif kbinp == "e"
            break
        end
    end
end


