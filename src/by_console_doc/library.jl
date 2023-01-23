"Alias for tracks_get_saved in tracks.jl"
library_get_saved_tracks(;limit=20, offset=0, market="") = tracks_get_saved(;limit, market, offset)


"Alias for show_get_saved in shows.jl"
library_get_saved_shows(;limit=20, offset=0) = show_get_saved(;limit, offset)


"Alias for album_get_saved in albums.jl"
library_get_saved_albums(;limit=20, offset=0, market="") = album_get_saved(;limit, offset, market)


"Alias for tracks_get_contains in tracks.jl"
library_check_saved_tracks(track_ids) = tracks_get_contains(track_ids)


"Alias for show_get_contains in shows.jl"
library_check_saved_shows(show_ids) = show_get_contains(show_ids)


"Alias for album_get_contains in albums.jl"
library_check_saved_albums(album_ids) = album_get_contains(album_ids)


#### DELETE ####

## https://developer.spotify.com/documentation/web-api/reference/library/remove-albums-user/
@doc """
# Remove Albums for Current User
**Summary**: Remove one or more albums for the current user's 'Your Music' library.\n

`album_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-albums-user/)
""" ->
function library_remove_albums(album_ids)
    return spotify_request("me/albums?ids=$album_ids", method="DELETE")
end



## https://developer.spotify.com/documentation/web-api/reference/library/remove-shows-user/
@doc """
# Remove Shows for Current User
**Summary**: Remove one or more shows for the current user's library.\n

`show_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-shows-user/)
""" ->
function library_remove_shows(show_ids)
    return spotify_request("me/shows?ids=$show_ids", method="DELETE")
end


## https://developer.spotify.com/documentation/web-api/reference/library/remove-tracks-user/
@doc """
# Remove Tracks for Current User
**Summary**: Remove one or more tracks for the current user's 'Your Music' library.\n

`track_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-tracks-user/)
""" ->
function library_remove_tracks(track_ids)
    return spotify_request("me/tracks?ids=$track_ids", method="DELETE")
end

#### PUT #####

## https://developer.spotify.com/documentation/web-api/reference/library/save-albums-user/
@doc """
# Save Albums for Current User
** Summary**: Save one or more albums to the current user's 'Your Music' library.\n

`album_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50. \n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-albums-user/)
""" ->
function library_save_album(album_ids)
    return spotify_request("me/albums?ids=$album_ids", method="PUT")
end


## https://developer.spotify.com/documentation/web-api/reference/library/save-shows-user/
@doc """
# Save Shows for Current User
** Summary**: Save one or more shows to the current user's library.\n

`shows_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50. \n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-shows-user/)
""" ->
function library_save_show(show_ids)
    return spotify_request("me/shows?ids=$show_ids", method="PUT")
end


## https://developer.spotify.com/documentation/web-api/reference/library/save-tracks-user/
@doc """
# Save Tracks for Current User
** Summary**: Save one or more tracks to the current user's 'Your Music' library.\n

`track_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50. \n

# Note
- Scope was unsufficient, also when accessed through the web console:
┌ Info: 403 (code meaning): Forbidden - The server understood the request, but is refusing to fulfill it.
└               (response message): Insufficient client scope

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-tracks-user/)
""" ->
function library_save_track(track_ids)
    return spotify_request("me/tracks?ids=$track_ids", method="PUT")
end