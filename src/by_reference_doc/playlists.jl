## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist
"""
    playlist_get(playlist_id::String; additional_types::String="track", fields::String="",
    market::String="US")

  **Summary**: Get details about a playlist owned by a Spotify user.

  # Arguments
  - `playlist_id::String` : Alphanumeric ID of the playlist

  # Optional keywords
  - `additional_types::String` : "track" (default) or "episode"
  - `fields::String` : Filters for the query, a comma-separated list of the fields to return.
                      For example, to get just the added date and user ID of the adder,
                      fields = "items(added_at,added_by.id)". Default is set to "", which means
                      all fields are returned.
  - `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                      only episodes that are available in that market will be returned.
                      Default is set to "US".

  # Example
  ```julia-repl
  julia> Spotify.playlist_get("37i9dQZF1E4vUblDJbCkV3")[1]
  JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 15 entries:
    :collaborative => false
    :description   => "With Roo Panes, Hiss Golden Messenger, Nathaniel Rateliff and more"
    :external_urls => {…
    :followers     => {…
    :href          => "https://api.spotify.com/v1/playlists/37i9dQZF1E4vUblDJbCkV3?additional_types=track"
    :id            => "37i9dQZF1E4vUblDJbCkV3"
    :images        => JSON3.Object[{…
    :name          => "Lord Huron Radio"
    :owner         => {…
    :primary_color => nothing
    :public        => false
    :snapshot_id   => "MTYzNTg2NzMxNCwwMDAwMDAwMGU3MTgwNDkzOWE5NTQ2NGM1NmYzNTYyZDhhZTc1ZGNh"
    :tracks        => {…
    :type          => "playlist"
    :uri           => "spotify:playlist:37i9dQZF1E4vUblDJbCkV3"
  ```
"""
function playlist_get(playlist_id; additional_types::String="track", fields::String="",
                      market::String="US")

    url1 = "playlists/$(playlist_id)?additional_types=$additional_types"
    url2 = "&fields=$fields&market=$market"

    return Spotify.spotify_request(url1 * url2)

end


# TODO playlist_change_details()
# https://developer.spotify.com/documentation/web-api/reference/#/operations/change-playlist-details

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks
"""
    playlist_get_tracks(playlist_id::String; additional_types="track", limit=50,
    offset=0, market="US")

**Summary**: Get details about the items of a playlist.

# Arguments
- `playlist_id::String` : Alphanumeric ID of the playlist

# Optional keywords
- `additional_types::String` : "track" (default) or "episode"
- `fields::String` : Filters for the query, a comma-separated list of the fields to return.
                    For example, to get just the added date and user ID of the adder,
                    fields = "items(added_at,added_by.id)". Default is set to "", which means
                    all fields are returned.
- `limit::Int64` : Maximum number of items to return, default is set to 20. Minimum: 1. Maximum: 50.
- `offset::Int64` : Index of the first item to return, default is set to 0
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                    only episodes that are available in that market will be returned.
                    Default is set to "US".

# Example
```julia-repl
julia> Spotify.playlist_get_tracks("37i9dQZF1E4vUblDJbCkV3")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
:href     => "https://api.spotify.com/v1/playlists/37i9dQZF1E4vUblDJbCkV3/tracks?offset=0&limit=20&market=US&additional_types=…
:items    => JSON3.Object[{…
:limit    => 20
:next     => "https://api.spotify.com/v1/playlists/37i9dQZF1E4vUblDJbCkV3/tracks?offset=20&limit=20&market=US&additional_types…
:offset   => 0
:previous => nothing
:total    => 50
```
"""
function playlist_get_tracks(playlist_id; additional_types::String="track", fields::String="",
                             limit::Int64=20, offset::Int64=0, market::String="US")

    url1 = "playlists/$(playlist_id)/tracks?additional_types=$additional_types"
    url2 = "&fields=$fields&limit=$limit&offset=$offset&market=$market"

    return Spotify.spotify_request(url1 * url2)

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/add-tracks-to-playlist
"""
    playlist_add_tracks_to_playlist(playlist_id::SpPlaylistId, ids::Vector{SpId}; position::Int = 0)

**Summary**: Add one or more items to a user's playlist.

# Arguments
- `playlist_id`::SpPlaylistId The Spotify ID of the playlist.
- `ids`::Vector{SpId}   A maximum of 100 items can be added in one request.
# Optional keywords
- `position`::Int     The position to insert the items, a zero-based index.
    For example, to insert the items in the first position: position=0;
    to insert the items in the third position: position=2.
    The default value is -1, meaning we omit the argument in the API call.
    When omitted, the items will be appended to the playlist. Items are added in the order they
    are listed in the query string or request body.

# Example
```
```
"""
function playlist_add_tracks_to_playlist(playlist_id::SpPlaylistId, ids::Vector{SpId}; position::Int = -1)
    method = "POST"
    spuris = map(ids) do id
        SpUri("spotify:track:$id")
    end
    @assert spuris isa Vector
    spstrings = map(spuris) do id
        "\"$id\""
    end
    content = join(spstrings, ", ")
    body = "{\"uris\": [" * content * "]}"
    println("body:")
    println(body)
    println()
    #"""{"name": "$name", "description": "$description",  "public": $public, "collaborative": $collaborative}"""

    url = "playlists/$playlist_id/tracks"
    if position != -1
        url *= "?position=$position"
    end
    return Spotify.spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end

# TODO playlist_reorder_or_replace_tracks()
## https://developer.spotify.com/documentation/web-api/reference/#/operations/reorder-or-replace-playlists-tracks

# TODO playlist_remove_tracks()
## https://developer.spotify.com/documentation/web-api/reference/#/operations/remove-tracks-playlist

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-list-of-current-users-playlists
"""
    playlist_get_current_user(limit::Int64=20, offset::Int64=0)

**Summary**: Get a list of the playlists owned or followed by the current Spotify user.

# Optional keywords
- `limit::Int64` : Maximum number of items to return, default is set to 20. Minimum: 1. Maximum: 50.
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> Spotify.playlist_get_current_user()[1]
[ Info: We try requests without checking if current grant includes the necessary scope, which is: playlist-read-private.
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
:href     => "https://api.spotify.com/v1/users/your_user_id/playlists?offset=0&limit=20"
:items    => JSON3.Object[{…
:limit    => 20
:next     => nothing
:offset   => 0
:previous => nothing
:total    => 2
```
"""
function playlist_get_current_user(;limit::Int64=20, offset::Int64=0)

    return Spotify.spotify_request("me/playlists?limit=$limit&offset=$offset"; scope = "playlist-read-private")

end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-list-users-playlists
"""
playlist_get_user(user_id::String; limit::Int64=20, offset::Int64=0)

**Summary**: Get a list of the playlists owned or followed by a Spotify user.

# Arguments
- `user_id::String` : Alphanumeric ID of the user or name (e.g. "smedjan")

# Optional keywords
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> Spotify.playlist_get_user("smedjan")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
:href     => "https://api.spotify.com/v1/users/smedjan/playlists?offset=0&limit=20"
:items    => JSON3.Object[{…
:limit    => 20
:next     => "https://api.spotify.com/v1/users/smedjan/playlists?offset=20&limit=20"
:offset   => 0
:previous => nothing
:total    => 98
```
"""
function playlist_get_user(user_id; limit::Int64=20, offset::Int64=0)
    return Spotify.spotify_request("users/$user_id/playlists?limit=$limit&offset=$offset")
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/create-playlist
"""
    playlist_create_playlist(name::String; user_id:: ,,,public::Bool = true, collaborative::Bool = false, description::String = "")

**Summary**: Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)

# Arguments
- `name::String` :   The name for the new playlist, for example "Your Coolest Playlist". This name does not need to be unique; a user may have several playlists with the same name.

# Optional keywords
- `user_id`                 Defaults to SpUserId(), from the .ini file
- `public`::Boolean         Defaults to true. If true the playlist will be public, if false it will be private. To be able to create private playlists, the user must have granted the playlist-modify-private scope
- `collaborative`::Boolean  Defaults to false. If true the playlist will be collaborative. Note: to create a collaborative playlist you must also set public to false. To create collaborative playlists you must have granted playlist-modify-private and playlist-modify-public scopes.
- `description`::String     Value for playlist description as displayed in Spotify Clients and in the Web API.

# Example
```
```
"""
function playlist_create_playlist(name::String; user_id = SpUserId(), public::Bool = true, collaborative::Bool = false, description::String = "")
    method = "POST"
    url = "users/$user_id/playlists"
    body = """{"name": "$name", "description": "$description",  "public": $public, "collaborative": $collaborative}"""
    return Spotify.spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end



## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-featured-playlists
"""
    playlist_get_featured(;country::String="US", limit::Int64=20, locale::String="en_US",
                               offset::Int64=0, timestamp::String="$(Dates.now())")

**Summary**: Get a list of Spotify featured playlists (shown, for example, on a Spotify player's 'Browse' tab).

# Optional keywords
- `country::String` : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    Default is set to "US".
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `locale::String` : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
                    ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
                    Provide this parameter if you want the results returned in a particular language (where available).
                    Default is set to "en_US".
- `offset::Int64` : Index of the first item to return, default is set to 0
- `timestamp::String` : A timestamp in ISO 8601 format: yyyy-MM-ddTHH:mm:ss. Use this parameter to specify the user's local time
                        to get results tailored for that specific date and time in the day.
                        Default is set to user's current time.

# Example
```julia-repl
julia> Spotify.playlist_get_featured(locale="en_UK")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 2 entries:
:message   => "Tuesday jams"
:playlists => {…
```
"""
function playlist_get_featured(;country::String="US", limit::Int64=20, locale::String="en_US",
                               offset::Int64=0, timestamp::String="$(Dates.now())")

    url1 = "browse/featured-playlists?country=$country&limit=$limit"
    url2 = "&locale=$locale&offset=$offset&timestamp=$timestamp"

    return Spotify.spotify_request(url1 * url2)

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-categories-playlists
"""
    playlist_get_category(category_id::String; country::String="US", limit::Int64=20, offset::Int64=0)

**Summary**: Get a list of Spotify playlists tagged with a particular category.

# Arguments
- `category_id::String` : The unique string identifying the Spotify category, e.g. "dinner", "party" etc.

# Optional keywords
- `country::String` : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    Default is set to "US".
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> Spotify.playlist_get_category("party")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
:playlists => {…
```
"""
function playlist_get_category(category_id; country::String="US", limit::Int64=20, offset::Int64=0)
    url1 = "browse/categories/$category_id/playlists?country=$country"
    url2 = "&limit=$limit&offset=$offset"
    return Spotify.spotify_request(url1 * url2)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist-cover
"""
    playlist_get_cover_image(playlist_id::String)

**Summary**: Get the current image associated with a specific playlist.

# Arguments
- `playlist_id::String` : Alphanumeric ID of the playlist

# Example
```julia-repl
julia> Spotify.playlist_get_cover_image("37i9dQZF1E4vUblDJbCkV3")[1]
1-element JSON3.Array{JSON3.Object, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
{
"height": nothing,
    "url": "https://seeded-session-images.scdn.co/v1/img/artist/6ltzsmQQbmdoHHbLZ4ZN25/en",
    "width": nothing
}
```
"""
function playlist_get_cover_image(playlist_id)
    return Spotify.spotify_request("playlists/$playlist_id/images")
end

# TODO playlist_upload_custom_cover()
## https://developer.spotify.com/documentation/web-api/reference/#/operations/upload-custom-playlist-cover