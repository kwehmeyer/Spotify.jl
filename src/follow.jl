# follow.jl
## https://developer.spotify.com/documentation/web-api/reference/follow/

#### GET ####

## https://developer.spotify.com/documentation/web-api/reference/follow/check-current-user-follows/
@docs """
# Check if Current User Follows Artists or Users
**Summary**: Check to see if the current user is following one or more artists or other Spotify Users

`type` _Required_: The ID type, either `artist` or `user`.\n 
`ids` _Required_: A comma separated list of the artist or user Spotify IDS to check. Maximum 50.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/check-current-user-follows/)
""" ->
function follow_check(type, ids)
    return spotify_request("me/following/contains?type=$type&ids=$ids")
end

## https://developer.spotify.com/documentation/web-api/reference/follow/check-user-following-playlist/
@docs """
# Check if Users Follow a Playlist
**Summary**: Check to see if one or more Spotify users are following a specified playlist_id.\n 

`playlist_id` _Required_: The Spotify ID of the playlist.\n 
`ids` _Required_: A comma separated list of the user Spotify IDS to check. Maximum 5.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/check-user-following-playlist/)
""" ->
function follow_check_playlist(playlist_id, ids)
    return spotify_request("playlists/$playlist_id/followers/contains?ids=$ids")
end


## https://developer.spotify.com/documentation/web-api/reference/follow/get-followed/
@doc """
# Get User's Followed Artists 
**Summary**: Get the current user's followed artists.

`type` _Required_: The ID type. Currently only `artist` is supported. Default `artist`.\n
`limit` _Optional_: The maximum number of items to return. Default 20, Minimum 1, Maximum 50. \n

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/get-followed/)
""" ->
function follow_artists(type="artist", limit=20)
    return spotify_request("me/following?type=$type")
end