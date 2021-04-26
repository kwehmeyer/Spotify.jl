# library.jl
## https://developer.spotify.com/documentation/web-api/reference/library/

## https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/
@doc """
# Get a User's Saved Tracks
**Summary**: Get a list of the songs saved in the current Spotify user's 'Your Music' library.\n 

`limit` _Optional_: The maximum number of objects to return. Default 20. Minimum 1. Maximum 50. \n
`offset` _Optional_: The index of the first object to return. Default 0.\n
`market` _Optional_: An ISO 3166-1 alpha-2 country code.

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/)
""" ->
function library_get_saved_tracks(limit=20, offset=0, market="US")
    return spotify_request("me/tracks?market=$market&offset=$offset&limit=$limit"; scope = "user-library-read")
end

## https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-shows/

@doc """
# Get a User's Saved Shows
**Summary**: Get a list of the songs saved in the current Spotify user's 'Your Music' library.\n 

`limit` _Optional_: The maximum number of objects to return. Default 20. Minimum 1. Maximum 50. \n
`offset` _Optional_: The index of the first object to return. Default 0.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-shows/)
""" ->
function library_get_saved_shows(limit=20, offset=0)
    return spotify_request("me/shows?limit=$limit&offset=$offset"; scope = "user-library-read")
end



## https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/
@doc """
# Get a User's Saved Albums
**Summary**: Get a list of the albums saved in the current Spotify user's 'Your Music' library.\n 

`limit` _Optional_: The maximum number of objects to return. Default 20. Minimum 1. Maximum 50. \n
`offset` _Optional_: The index of the first object to return. Default 0.\n
`market` _Optional_: An ISO 3166-1 alpha-2 country code.

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/)
""" ->
function library_get_saved_albums(limit=20, offset=0, market="US")
    return spotify_request("me/albums?limit=$limit&offset=$offset&market=$market"; scope = "user-library-read")
end



## https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-tracks/
@doc """
# Check User's Saved Tracks
**Summary**: Check if one or more tracks is already saved in the current Spotify user's 'Your Music' library.\n 

`track_ids` _Required_: A comma-separated list of the Spotify IDs for the tracks. Maximum 50.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-tracks/)
""" -> 
function library_check_saved_tracks(track_ids)
    return  spotify_request("me/tracks/contains?ids=$track_ids")
end


## https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-shows/
@doc """
# Check User's Saved Shows
**Summary**: Check if one or more shows is already saved in the current Spotify user's library.\n 

`show_ids` _Required_: A comma separated list of the Spotify IDs for the shows. Maximum 50\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-shows/)
""" ->
function library_check_saved_shows(show_ids)
    return spotify_request("me/shows/contains?ids=$show_ids")
end



## https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-albums/
@doc """
# Check User's Saved Albums
**Summary**: Check if one or more albums is already saved in the current Spotify user's 'Your Music' library.\n 

`album_ids` _Required_: A comma separated list of the Spotify IDs for the albums. Max 50.\n 

[Required](https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-albums/)
""" ->
function library_check_saved_albums(album_ids)
    return spotify_request("me/albums/contains?ids=$album_ids")
end


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
function library_save_show(shows_ids)
    return spotify_request("me/shows?ids=$show_ids", method="PUT")
end


## https://developer.spotify.com/documentation/web-api/reference/library/save-tracks-user/
@doc """
# Save Tracks for Current User
** Summary**: Save one or more tracks to the current user's 'Your Music' library.\n 

`track_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50. \n

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-tracks-user/)
""" ->
function library_save_track(track_ids)
    return spotify_request("me/tracks?ids=$track_ids", method="PUT")
end