"""
    users_check_current_follows(item_type, ids)

**Summary**: Check to see if the current user is following one or more artists or other Spotify users.

# Arguments
- `ids` _Required_:     - A comma separated list of the artist. Maximum 50.
                        - a single user.
- `item_type` _Optional_: The ID type, either `artist` (default) or `user`.

# Example
```julia-repl
julia> users_check_current_follows(["0YC192cP3KPCRWx8zr8MfZ"])[1]
1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0

 julia> users_check_current_follows("smedjan"; item_type = "user")[1]
 1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
  0
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/check-current-user-follows)
"""
function users_check_current_follows(artist_ids; item_type = "artist")
    if item_type == "artist"
        ids = SpArtistId.(artist_ids)
    elseif item_type == "user"
        ids = artist_ids
    else
        throw(ArgumentError("item type"))
    end
    u = "me/following/contains"
    a = urlstring(; type = item_type, ids)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-follow-read")
end


"""
    users_check_follows_playlist(playlist_id, user_id)

**Summary**: Check to see if one or more Spotify users are following a specified playlist_id.\n

# Arguments
- `playlist_id` _Required_: The Spotify ID of the playlist.\n
- `user_id` _Required_: A comma separated list of the user Spotify IDS to check. Maximum 5.\n

# Example
```julia-repl
julia> users_check_follows_playlist("3cEYpjA9oz9GiPac4AsH4n", ["jmperezperez", "thelinmichael", "wizzler"])[1]
3-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
 0
 0
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/check-if-user-follows-playlist)
"""
function users_check_follows_playlist(playlist_id, user_ids)
    pid = SpPlaylistId(playlist_id)
    u = "playlists/$pid/followers/contains"
    a = urlstring(; ids = user_ids)
    url = build_query_string(u, a)
    spotify_request(url; scope = "playlist-read-private")
end


"""
    users_follow_artists_users(artist_ids; type= "artist")

# Follow Artists or Users
**Summary**: Add the current user as a follower of one or more artists or other Spotify users.\n

# Arguments
`artist_ids` _Required_: A comma-separated list of the artists or users Spotify IDs. Maximum 50.
`type` _Optional_: The ID type: either `artist` (default) or `user`


# Example
```julia-repl
julia> artist_ids = SpArtistId.(["2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6"])
3-element Vector{SpArtistId}:
 spotify:artist:2CIMQHirSU0MQqyYHq0eOx
 spotify:artist:57dN52uHvrHOxijzpIgu3E
 spotify:artist:1vCWHaC5f2uS3yhpwWbIA6

julia> users_follow_artists_users(artist_ids)[1]
{}

julia> # Cleanup

julia> users_unfollow_artists_users(artist_ids)
{}
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
"""
function users_follow_artists_users(artist_ids; type= "artist")
    method = "PUT"
    ids = SpArtistId.(artist_ids)
    u = "me/following"
    a = urlstring(; ids, type)
    url = build_query_string(u, a)
    spotify_request(url, method; scope = "user-follow-modify")
end


"""
    users_follow_playlist(playlist_id; public = false)

**Summary**: Add the current user as a follower of a playlist.

# Argument
-`playlist_id`: The Spotify ID of the playlist. Any playlist can be followed regardless of it's private/public status, as long as the ID is known.

# Optional argument
- `public`:     Defaults to false. If true the playlist will be included in user's public playlists,
                if false it will remain private.

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/follow-playlist/)

# Example
```julia-repl
julia> playlist_id = SpPlaylistId("37i9dQZF1DX1rVvRgjX59F")
spotify:playlist:37i9dQZF1DX1rVvRgjX59F

julia> users_follow_playlist(playlist_id)[1]
{}

julia> users_unfollow_playlist(playlist_id)[1] # Cleanup
{}
```
"""
function users_follow_playlist(playlist_id; public = false)
    method = "PUT"
    pid = SpPlaylistId(playlist_id)
    url = "playlists/$pid/followers"
    body = body_string(;public)
    scope  = "playlist-modify-private"
    additional_scope = "playlist-modify-public"
    spotify_request(url, method; body, scope, additional_scope)
end


"""
    users_get_current_profile()

    **Summary**: Get detailed profile information about the current user
                (including the current user's username).

    The returned object contains more info when granted scopes: user-read-private and  user-read-email.

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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile)
"""
function users_get_current_profile()
    spotify_request("me"; scope = "user-read-private", additional_scope = "user-read-email")
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks)
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


"""
    users_get_follows(; limit = 20, after = "")

**Summary**: Get the current user's followed artists.

# Arguments
- `limit` _Optional_: The maximum number of items to return. Default 20, Minimum 1, Maximum 50.
- `after` _Optional_: The last artist ID retrieved from the previous request.

# Example
```julia-repl
julia> o = users_get_follows(;limit = 10)[1];

julia> anames = [s.name for s in o.artists.items];

julia> while rem(length(anames), 10)  == 0
           id =  o.artists.items[end].id
           o = users_get_follows(;after = id)[1]
           anames = vcat(anames, [s.name for s in o.artists.items])
end

julia> julia> length(anames)
26
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed)
"""
function users_get_follows(; limit = 20, after = "")
    type = "artist"
    u = "me/following"
    a = urlstring(; type, limit, after)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-follow-read")
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-profile)
"""
function users_get_profile(user_id)
    spotify_request("users/$user_id")
end


"""
    users_unfollow_artists_users(artist_ids; type = "artist")

**Summary**: Remove the current user as a follower of one or more artists or other Spotify users.

# Arguments
- `artist_ids` _Required_: A comma-separated list of the artists' or users' Spotify IDs. Maximum 50.

# Optional keyword arguments

- `type`:  Either "artist" (default) or "user".

```julia-repl
julia> artist_ids = ["2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6"]
3-element Vector{String}:
 "2CIMQHirSU0MQqyYHq0eOx"
 "57dN52uHvrHOxijzpIgu3E"
 "1vCWHaC5f2uS3yhpwWbIA6"

julia> users_unfollow_artists_users(artist_ids])[1]
{}
```
[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-artists-users/)
"""
function users_unfollow_artists_users(artist_ids; type = "artist")
    method = "DELETE"
    u = "me/following"
    a = urlstring(; type)
    url = build_query_string(u, a)
    ids = SpId.(artist_ids)
    body = body_string(;ids)
    spotify_request(url, method; body, scope = "user-follow-modify")
end


"""
    users_unfollow_playlist(playlist_id)

**Summary**: Remove the current user as a follower of a playlist. If none are following, this substitutes for 'delete'.

`playlist_id` _Required_: The Spotify ID of the playlist. Any playlist can be followed regardless of it's private/public status, as long as the ID is known.\n

# Arguments
- `playlist_id` The Spotify ID of the playlist.

# Example

To be run after example in `playlist_create_playlist`, possibly also 'playlist_remove_playlist_item`.
```julia-repl
julia> users_unfollow_playlist(myownplaylistid)[1]
{}
```

Also see `users_follow_playlist`

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/unfollow-playlist/)
"""
function users_unfollow_playlist(playlist_id)
    method = "DELETE"
    pid = SpPlaylistId(playlist_id)
    url = "playlists/$pid/followers"
    spotify_request(url, method; scope= "playlist-modify-private")
end