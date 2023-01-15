# Also see related functions in users.jl and personalization.jl

#### GET ####

## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-current-user-follows
"""
    follow_check(item_type, ids)

**Summary**: Check to see if the current user is following one or more artists or other Spotify users.

# Arguments
- `item_type` _Required_: The ID type, either `artist` or `user`.\n
- `ids` _Required_: A comma separated list of the artist or user Spotify IDs to check. Maximum 50.\n

# Example
```julia-repl
julia> follow_check("artist", "7fxBPUc2bTUgl7GLuqjajk")[1]
1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
```
"""
function follow_check(item_type, ids)

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
julia> follow_check_playlist("3cEYpjA9oz9GiPac4AsH4n", "jmperezperez, thelinmichael, wizzler")[1]
     GET https://api.spotify.com/v1/playlists/3cEYpjA9oz9GiPac4AsH4n/followers/contains?ids=jmperezperez,thelinmichael,wizzler
     scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "playlist-read-private"]
3-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
 0
 0
```
```
"""
function follow_check_playlist(playlist_id, user_ids)

    return spotify_request("playlists/$playlist_id/followers/contains?ids=$user_ids"; scope = "playlist-read-private")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed
"""
    follow_get(;item_type="artist", limit=20)

**Summary**: Get the current user's followed artists.

# Arguments
- `item_type` _Required_: The ID type. Currently only `artist` is supported. Default `artist`.\n
- `limit` _Optional_: The maximum number of items to return. Default 20, Minimum 1, Maximum 50. \n

# Example
```julia-repl
julia> follow_get()[1]["artists"]
     GET https://api.spotify.com/v1/me/following?type=artist&limit=20
     scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "user-follow-modify"]
JSON3.Object{Base.CodeUnits{UInt8, String}, SubArray{UInt64, 1, Vector{UInt64}, Tuple{UnitRange{Int64}}, true}} with 6 entries:
  :items   => JSON3.Object[{…
  :next    => "https://api.spotify.com/v1/me/following?type=artist&after=6A43Djmhbe9100UwnI7epV&limit=20"
  :total   => 24
  :cursors => {…
  :limit   => 20
  :href    => "https://api.spotify.com/v1/me/following?type=artist&limit=20"
```
"""
function follow_get(;item_type="artist", limit=20)

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
function follow_get_users(type, ids)
    #@show "me/following?type=$type&ids=$ids"
   #return spotify_request("me/following/contains?type=$item_type&ids=$ids"; scope = "user-follow-read")
    return spotify_request("me/following?type=$type&ids=$ids", "PUT"; scope = "user-follow-modify")
end

## https://developer.spotify.com/documentation/web-api/reference/follow/follow-playlist/
@doc """
# Follow a Playlist
**Summary**: Add the currend user as a follower of a playlist.

# Argument
-`playlist_id`: The Spotify ID of the playlist. Any playlist can be followed regardless of it's private/public status, as long as the ID is known.\n

# Optional argument
- `public`:     Defaults to false. If true the playlist will be included in user's public playlists, 
                if false it will remain private.

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/follow-playlist/)

# Examples
```julia-repl
julia> playlist_id = SpPlaylistId("37i9dQZF1DX1rVvRgjX59F");
julia> follow_playlist(playlist_id; public = false)
    PUT https://api.spotify.com/v1/playlists/37i9dQZF1DX1rVvRgjX59F/followers   \\{"public": false}
    scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "user-modify-playback-state", "playlist-modify-private", "playlist-modify-public"]
[ Info: 200: OK - The request has succeeded. The client can read the result of the request in the body and the headers of the response.
julia> 
```
""" 
function follow_playlist(playlist_id; public = false)
    url = "playlists/$playlist_id/followers"
    body = bodystring(;public)
    scope  = "playlist-modify-private"
    additional_scope = "playlist-modify-public"
    return spotify_request(url, "PUT"; body, scope, additional_scope)
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
    # TODO fix
    throw("Not yet implemented and kind of dangerous. Fix the body and the url!")
    body = "{\"public\": $public}"
    scope  = "playlist-modify-private"
    additional_scope = "playlist-modify-public"
    return spotify_request("me/following?type=$type&ids=$ids", "DELETE"; scope = "user-follow-modify")
end

## https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-playlist/
@doc """
# Unfollow a Playlist
**Summary**: Remove the current user as a follower of a playlist.\n

`playlist_id` _Required_: The Spotify ID of the playlist. Any playlist can be followed regardless of it's private/public status, as long as the ID is known.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-playlist/)
""" ->
function unfollow_playlist(playlist_id)
    body = "{\"public\": $public}"
    scope  = "playlist-modify-private"
    additional_scope = "playlist-modify-public"
    throw("Not yet implemented and kind of dangerous. Fix the body and the url!")
    return spotify_request("playlists/$playlist_id/followers", method="DELETE"; scope = "playlist-modify-private")
end