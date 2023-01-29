# Also see related functions in follow.jl and personalization.jl

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



## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks

"""
    users_get_current_user_top_items()

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

# Implemented in follow.jl
# follow_get(type="artist", limit = 20)


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-current-user-follows

# Implemented in follow.jl
# follow_check(type, ids)


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-if-user-follows-playlist

# Implemented in follow.jl
# follow_check_playlist(playlist_id, ids)




