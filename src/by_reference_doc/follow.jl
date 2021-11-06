# Also see related functions in users.jl and personalization.jl

#### GET ####

## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-current-user-follows
"""
    follow_check(item_type, ids)

**Summary**: Check to see if the current user is following one or more artists or other Spotify users.

# Arguments
- `item_type::String` _Required_: The ID type, either `artist` or `user`.\n 
- `ids::String` _Required_: A comma separated list of the artist or user Spotify IDs to check. Maximum 50.\n 

# Example
```julia-repl
julia> Spotify.follow_check("artist", "7fxBPUc2bTUgl7GLuqjajk")[1]
[ Info: We try the request without checking if current grant includes scope user-follow-read.
1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
```
"""
function follow_check(item_type::String, ids::String)

    return spotify_request("me/following/contains?type=$item_type&ids=$ids"; scope = "user-follow-read")

end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-if-user-follows-playlist
"""
    follow_check_playlist(playlist_id::String, user_id::String)

**Summary**: Check to see if one or more Spotify users are following a specified playlist_id.\n 

# Arguments
- `playlist_id::String` _Required_: The Spotify ID of the playlist.\n 
- `user_id::String` _Required_: A comma separated list of the user Spotify IDS to check. Maximum 5.\n 

# Example
```julia-repl
julia> Spotify.follow_check_playlist("37i9dQZF1DZ06evO3Khq6I", user_id)[1]
1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
```
"""
function follow_check_playlist(playlist_id, user_id)

    return spotify_request("playlists/$playlist_id/followers/contains?ids=$user_id"; scope = "playlist-read-private")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed
"""
    follow_artists(item_type::String="artist", limit::Int64=20)
 
**Summary**: Get the current user's followed artists.

# Arguments
- `item_type::String` _Required_: The ID type. Currently only `artist` is supported. Default `artist`.\n
- `limit::Int64` _Optional_: The maximum number of items to return. Default 20, Minimum 1, Maximum 50. \n

# Example
```julia-repl
julia> Spotify.follow_artists()[1]["artists"]
[ Info: We try the request without checking if current grant includes scope user-follow-modify.
JSON3.Object{Base.CodeUnits{UInt8, String}, SubArray{UInt64, 1, Vector{UInt64}, Tuple{UnitRange{Int64}}, true}} with 6 entries:
  :items   => JSON3.Object[{…
  :next    => nothing
  :total   => 2
  :cursors => {…
  :limit   => 20
  :href    => "https://api.spotify.com/v1/me/following?type=artist&limit=20"
```
"""
function follow_artists(item_type::String="artist", limit::Int64=20)

    return spotify_request("me/following?type=$item_type&limit=$limit"; scope = "user-follow-modify")

end

#### PUT ####

## https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/
@doc """
# Follow Artists or Users
**Summary**: Add the current user as a follower of one or more artists or other Spotify users.\n 

`type` _Required_: The ID type: either `artist` or `user`. \n 
`ids` _Required_: A comma-separated list of the artists or users Spotify IDs. Maximum 50.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
""" ->
function follow_artists_users(type, ids)
    return spotify_request("me/following?type=$type&ids=$ids", method="PUT"; scope = "user-follow-modify")
end

## https://developer.spotify.com/documentation/web-api/reference/follow/follow-playlist/
@doc """
# Follow a Playlist
**Summary**: Add the currend user as a follower of a playlist. \n 

`playlist_id` _Required_: The Spotify ID of the playlist. Any playlist can be followed regardless of it's private/public status, as long as the ID is known.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/follow-playlist/)
""" ->
function follow_playlist(playlist_id)
    return spotify_request("playlists/$playlist_id/followers", method="PUT"; scope = "user-follow-modify")
end

#### DELETE ####

## https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-artists-users/
@doc """
# Unfollow Artists or Users 
**Summary**: Remove the current user as a follower of one or more artists or other Spotify users.\n 

`type` _Required_: The ID type: either `artist` or `user`. \n 
`ids` _Required_: A comma-separated list of the artists or users Spotify IDs. Maximum 50.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-artists-users/)
""" ->
function unfollow_artists_users(type, ids)
    return spotify_request("me/following?type=$type&ids=$ids", method="DELETE"; scope = "user-follow-modify")
end

## https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-playlist/
@doc """
# Unfollow a Playlist
**Summary**: Remove the current user as a follower of a playlist.\n 

`playlist_id` _Required_: The Spotify ID of the playlist. Any playlist can be followed regardless of it's private/public status, as long as the ID is known.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-playlist/)
""" ->
function unfollow_playlist(playlist_id)
    return spotify_request("playlists/$playlist_id/followers", method="DELETE"; scope = "playlist-modify-private")
end