



## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-current-user-follows
"""
    users_check_current_follows(item_type, ids)

**Summary**: Check to see if the current user is following one or more artists or other Spotify users.

# Arguments
- `item_type` _Required_: The ID type, either `artist` or `user`.\n
- `ids` _Required_: A comma separated list of the artist or user Spotify IDs to check. Maximum 50.\n

# Example
```julia-repl
julia> users_check_current_follows("artist", "7fxBPUc2bTUgl7GLuqjajk")[1]
1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
```
"""
function users_check_current_follows(item_type, ids)
    return spotify_request("me/following/contains?type=$item_type&ids=$ids"; scope = "user-follow-read")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-if-user-follows-playlist
"""
    users_check_follows_playlist(playlist_id, user_id)

**Summary**: Check to see if one or more Spotify users are following a specified playlist_id.\n

# Arguments
- `playlist_id` _Required_: The Spotify ID of the playlist.\n
- `user_id` _Required_: A comma separated list of the user Spotify IDS to check. Maximum 5.\n

# Example
```julia-repl
julia> users_check_follows_playlist("3cEYpjA9oz9GiPac4AsH4n", "jmperezperez, thelinmichael, wizzler")[1]
     GET https://api.spotify.com/v1/playlists/3cEYpjA9oz9GiPac4AsH4n/followers/contains?ids=jmperezperez,thelinmichael,wizzler
     scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "playlist-read-private"]
3-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
 0
 0
```
```
"""
function users_check_follows_playlist(playlist_id, user_ids)
    return spotify_request("playlists/$playlist_id/followers/contains?ids=$user_ids"; scope = "playlist-read-private")
end



## https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/
@doc """
# Follow Artists or Users
**Summary**: Add the current user as a follower of one or more artists or other Spotify users.\n

`type` _Required_: The ID type: either `artist` or `user`. \n
`ids` _Required_: A comma-separated list of the artists or users Spotify IDs. Maximum 50.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
""" ->
function users_follow_artists_users(type, ids)
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
julia> users_follow_playlist(playlist_id; public = false)
    PUT https://api.spotify.com/v1/playlists/37i9dQZF1DX1rVvRgjX59F/followers   \\{"public": false}
    scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "user-modify-playback-state", "playlist-modify-private", "playlist-modify-public"]
[ Info: 200: OK - The request has succeeded. The client can read the result of the request in the body and the headers of the response.
julia> 
```
""" 
function users_follow_playlist(playlist_id; public = false)
    url = "playlists/$playlist_id/followers"
    body = bodystring(;public)
    scope  = "playlist-modify-private"
    additional_scope = "playlist-modify-public"
    return spotify_request(url, "PUT"; body, scope, additional_scope)
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile

"""
    users_get_current_profile()

    **Summary**: Get detailed profile information about the current user
                (including the current user's username).

# Example
```julia-repl
julia> users_get_current_profile()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 12 entries:
  :country          => "NL"
  :display_name     => "Itachi"
  :email            => "your_id@gmail.com"
  :explicit_content => {…
  :external_urls    => {…
  :followers        => {…
  :href             => "https://api.spotify.com/v1/users/your_user_id"
  :id               => "your_user_id"
  :images           => Union{}[]
  :product          => "premium"
  :type             => "user"
  :uri              => "spotify:user:your_user_id"
```
"""
function users_get_current_profile()

    spotify_request("me"; scope = "user-read-private")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks

"""
    users_get_current_user_top_items(;type = "artists", time_range = "medium_term", limit = 20, offset = 0)

**Summary**: Get the current user's top artists or tracks based on calculated affinity.

# Optional keywords
- `type`        : The type of entity to return. Valid values: "artists" or "tracks". Default: "artists".
- `limit`       : The maximum number of items to return. Default is set to 20. The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.
- `offset`      : The index of the first item to return. Default is 0.
- `time_range`  : Over what time frame the affinities are computed.
    Valid values: long_term (calculated from several years of data and including all
    new data as it becomes available), medium_term (approximately last 6 months),
    short_term (approximately last 4 weeks). Default: "medium_term".

# Example
```julia-repl
julia> users_get_current_user_top_items()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :items    => JSON3.Object[{…
  :total    => 50
  :limit    => 20
  :offset   => 0
  :previous => nothing
  :href     => "https://api.spotify.com/v1/me/top/artists"
  :next     => "https://api.spotify.com/v1/me/top/artists?limit=20&offset=20"julia> users_get_current_user_top_items(limit=1, type="tracks")[1].items;
```

The above used the default 'type' argument. We can also look for tracks:

```julia-repl
julia> users_get_current_user_top_items(type="tracks")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :items    => JSON3.Object[{…
  :total    => 50
  :limit    => 20
  :offset   => 0
  :previous => nothing
  :href     => "https://api.spotify.com/v1/me/top/tracks"
  :next     => "https://api.spotify.com/v1/me/top/tracks?limit=20&offset=20"
```
"""
function users_get_current_user_top_items(;type = "artists",
        time_range = "medium_term", limit = 20, offset = 0)
    @assert type == "artists" || type == "tracks"
    @assert time_range == "medium_term" ||
        time_range == "long_term" ||
        time_range == "short_term"
    u1 = "me/top/" * urlstring(type)
    u2 = urlstring(; time_range, limit, offset)
    url = build_query_string(u1, u2)
    spotify_request(url; scope = "user-top-read", additional_scope = "user-read-email")
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed
"""
    users_get_follows(;item_type = "artist", limit = 20)

**Summary**: Get the current user's followed artists.

# Arguments
- `item_type` _Required_: The ID type. Currently only `artist` is supported. Default `artist`.\n
- `limit` _Optional_: The maximum number of items to return. Default 20, Minimum 1, Maximum 50. \n

# Example
```julia-repl
julia> users_get_follows()[1]["artists"]
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
function users_get_follows(;item_type = "artist", limit = 20)
    return spotify_request("me/following?type=$item_type&limit=$limit"; scope = "user-follow-modify")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-profile

"""
    users_get_profile(user_id)

**Summary**: Get public profile information about a Spotify user.

# Arguments
- `user_id` : Alphanumeric ID of the user or name (e.g. "smedjan")

# Example
```julia-repl
julia> users_get_profile("smedjan")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 8 entries:
  :display_name  => "smedjan"
  :external_urls => {…
  :followers     => {…
  :href          => "https://api.spotify.com/v1/users/smedjan"
  :id            => "smedjan"
  :images        => Union{}[]
  :type          => "user"
  :uri           => "spotify:user:smedjan"
```
"""
function users_get_profile(user_id)
    spotify_request("users/$user_id")
end



## https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-artists-users/
@doc """
# Unfollow Artists or Users
**Summary**: Remove the current user as a follower of one or more artists or other Spotify users.\n

`type` _Required_: The ID type: either `artist` or `user`. \n
`ids` _Required_: A comma-separated list of the artists or users Spotify IDs. Maximum 50.\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-artists-users/)
""" ->
function users_unfollow_artists_users(type, ids)
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
function users_unfollow_playlist(playlist_id)
    body = "{\"public\": $public}"
    scope  = "playlist-modify-private"
    additional_scope = "playlist-modify-public"
    throw("Not yet implemented and kind of dangerous. Fix the body and the url!")
    return spotify_request("playlists/$playlist_id/followers", method = "DELETE"; scope = "playlist-modify-private")
end