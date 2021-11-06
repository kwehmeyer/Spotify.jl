# Also see related functions in follow.jl and personalization.jl

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile

"""
    user_get_current_profile()

    **Summary**: Get detailed profile information about the current user 
                (including the current user's username).

# Example
```julia-repl
julia> Spotify.user_get_current_profile()[1]
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
function user_get_current_profile()

    return Spotify.spotify_request("me"; scope = "user-read-private")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks

# Implemented in personalization.jl
# top_tracks(offset=0, limit=20, time_range="medium")
# top_artists(offset=0, limit=20, time_range="medium")

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-profile

"""
    user_get_profile(user_id::String)

**Summary**: Get public profile information about a Spotify user.

# Arguments
- `user_id::String` : Alphanumeric ID of the user or name (e.g. "smedjan") 

# Example
```julia-repl
julia> Spotify.user_get_profile("smedjan")[1]
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
function user_get_profile(user_id)

    return Spotify.spotify_request("users/$user_id")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed

# Implemented in follow.jl
# follow_artists(type="artist", limit=20)


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-current-user-follows

# Implemented in follow.jl
# follow_check(type, ids)


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-if-user-follows-playlist

# Implemented in follow.jl
# follow_check_playlist(playlist_id, ids)