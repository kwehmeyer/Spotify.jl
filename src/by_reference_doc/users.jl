# Also see related functions in follow.jl and personalization.jl

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile

"""
    users_get_current_profile()

    **Summary**: Get detailed profile information about the current user
                (including the current user's username).

# Example
```julia-repl
julia> Spotify.users_get_current_profile()[1]
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

    return Spotify.spotify_request("me"; scope = "user-read-private")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-profile

"""
    users_get_profile(user_id::String)

**Summary**: Get public profile information about a Spotify user.

# Arguments
- `user_id::String` : Alphanumeric ID of the user or name (e.g. "smedjan")

# Example
```julia-repl
julia> Spotify.users_get_profile("smedjan")[1]
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

    return Spotify.spotify_request("users/$user_id")

end



## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks

"""
    users_get_current_user_top_items()

    **Summary**: Get the current user's top artists or tracks based on calculated affinity.

# Optional keywords
- `type::String : The type of entity to return. Valid values: "artists" or "tracks". Default: "artists".
- `limit`       : The maximum number of items to return. Default is set to 20. The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.
- `offset`      : The index of the first item to return. Default is 0.
- `time_range::String`  : Over what time frame the affinities are computed.
    Valid values: long_term (calculated from several years of data and including all
    new data as it becomes available), medium_term (approximately last 6 months),
    short_term (approximately last 4 weeks). Default: "medium_term".

# Example
```
julia> # This function seems to require more scopes than 'user-top-read', which is documented in the reference.
julia> Spotify.apply_and_wait_for_implicit_grant()  # Get the default list of scopes, which are sufficient.
julia> users_get_current_user_top_items(limit=1)[1].items
     scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read"]
1-element JSON3.Array{JSON3.Object, Base.CodeUnits{UInt8, String}, SubArray{UInt64, 1, Vector{UInt64}, Tuple{UnitRange{Int64}}, true}}:
 {
   "external_urls": {
                       "spotify": "https://open.spotify.com/artist/6GI52t8N5F02MxU0g5U69P"
                    },
       "followers": {
                        "href": nothing,
                       "total": 2810952
                    },
          "genres": [
                      "blues rock",
                      "classic rock",
                      "mexican classic rock"
                    ],
            "href": "https://api.spotify.com/v1/artists/6GI52t8N5F02MxU0g5U69P",
              "id": "6GI52t8N5F02MxU0g5U69P",
          "images": [
                      {
                         "height": 640,
                            "url": "https://i.scdn.co/image/ab6761610000e5eb09882b1b7b33732abd60fc38",
                          "width": 640
                      },
                      {
                         "height": 320,
                            "url": "https://i.scdn.co/image/ab6761610000517409882b1b7b33732abd60fc38",
                          "width": 320
                      },
                      {
                         "height": 160,
                            "url": "https://i.scdn.co/image/ab6761610000f17809882b1b7b33732abd60fc38",
                          "width": 160
                      }
                    ],
            "name": "Santana",
      "popularity": 70,
            "type": "artist",
             "uri": "spotify:artist:6GI52t8N5F02MxU0g5U69P"
}
julia> users_get_current_user_top_items(limit=1, type="tracks")[1].items;
```
"""
function users_get_current_user_top_items(;type::String = "artists",
    time_range::String = "medium_term", limit = 20, offset = 0)
    @assert type == "artists" || type == "tracks"
    @assert time_range == "medium_term" ||
        time_range == "long_term" ||
        time_range == "short_term"
    pth = "me/top/$type?time_range=$time_range&limit=$limit&offset=$offset"

    return Spotify.spotify_request(pth; scope = "user-top-read", additional_scope = "user-read-email")

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




