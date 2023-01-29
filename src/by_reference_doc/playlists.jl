## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist
"""
    playlist_get(playlist_id; additional_types = "track", fields = "",
    market = "")

  **Summary**: Get details about a playlist owned by a Spotify user.

  # Arguments
  - `playlist_id` : Alphanumeric ID of the playlist

  # Optional keywords
  - `additional_types`: "track" (default) or "episode"
  - `fields`         : Filters for the query, a comma-separated list of the fields to return.
                      For example, to get just the added date and user ID of the adder,
                      fields = "items(added_at,added_by.id)". Default is set to "", which means
                      all fields are returned.
  - `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                      only episodes that are available in that market will be returned.
                      Default is set to "US".

  # Example
  ```julia-repl
  julia> using Spotify, Spotify.Playlists
  julia> playlist_get("37i9dQZF1E4vUblDJbCkV3")[1]
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
function playlist_get(playlist_id; additional_types = "track", fields = "",
                      market = "")
    u = "playlists/$(playlist_id)"
    a  = urlstring(;additional_types, fields, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


# TODO playlist_change_details()
# https://developer.spotify.com/documentation/web-api/reference/#/operations/change-playlist-details

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks
"""
    playlist_get_tracks(playlist_id; additional_types = "track", limit = 50,
    offset = 0, market = "")

**Summary**: Get details about the items of a playlist.

# Arguments
- `playlist_id`   : Alphanumeric ID of the playlist

# Optional keywords
- `additional_types` : "track" (default) or "episode"
- `fields` : Filters for the query, a comma-separated list of the fields to return.
                    For example, to get just the added date and user ID of the adder,
                    fields = "items(added_at,added_by.id)". Default is set to "", which means
                    all fields are returned.
- `limit`          : Maximum number of items to return, default is set to 20. Minimum: 1. Maximum: 50.
- `offset`         : Index of the first item to return, default is set to 0
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                    only episodes that are available in that market will be returned.
                    Default is set to "US".

# Example
```julia-repl
julia> playlist_get_tracks("37i9dQZF1E4vUblDJbCkV3")[1]
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
function playlist_get_tracks(playlist_id; additional_types = "track", fields = "",
                             limit = 20, offset = 0, market = "")
    u = "playlists/$(playlist_id)/tracks"
    a = urlstring(;additional_types, fields, limit, offset, market)
    url = build_query_string(u, a)
    spotify_request(url; scope = "playlist-read-private")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/add-tracks-to-playlist
"""
    playlist_add_tracks_to_playlist(playlist_id, track_uris; position = 0)

**Summary**: Add one or more items to a user's playlist.

# Arguments
- `playlist_id`:  The Spotify ID of the playlist.
- `track_uris`:   A maximum of 100 items can be added in one request.
# Optional keywords
- `position`:     The position to insert the items, a zero-based index.
    For example, to insert the items in the first position: position = 0;
    to insert the items in the third position: position = 2.
    The default value is -1, meaning we omit the argument in the API call.
    When omitted, the items will be appended to the playlist. Items are added in the order they
    are listed in the query string or request body.

# Example
```julia-repl
playlist_add_tracks_to_playlist("3cEYpjA9oz9GiPac4AsH4n", ["spotify:track:4m6P9J3czb5hiMIuNsWeVO", "spotify:track:619OpJGKpAOrp5rM4Gcs65"])[1]
    POST https://api.spotify.com/v1/playlists/3cEYpjA9oz9GiPac4AsH4n/tracks   \\{"uris": ["spotify:track:4m6P9J3czb5hiMIuNsWeVO", "spotify:track:619OpJGKpAOrp5rM4Gcs65"]}
    scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "playlist-modify-public", "playlist-modify-private", "playlist-read-private"]
┌ Info: 403 (code meaning): Forbidden - The server understood the request, but is refusing to fulfill it.
└               (response message): You cannot add tracks to a playlist you don't own.
    This code may be triggered by insufficient authorization scope(s).
    Consider: `Spotify.apply_and_wait_for_implicit_grant()`  scope(s) required for this API call: playlist-modify-public playlist-modify-private
    scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "playlist-modify-public", "playlist-modify-private", "playlist-read-private"]
```

Or, more formally
```julia-repl
julia> myownplaylist = playlist_get_current_user()[1].items[1].id |> SpId
"2Se75n0Lh0Nod77qxHImrd"

julia> track_uris = SpUri.(["4m6P9J3czb5hiMIuNsWeVO", "619OpJGKpAOrp5rM4Gcs65"]);

julia> playlist_add_tracks_to_playlist(myownplaylist, track_uris)
    POST https://api.spotify.com/v1/playlists/2Se75n0Lh0Nod77qxHImrd/tracks   \\{"uris": ["spotify:track:4m6P9J3czb5hiMIuNsWeVO", "spotify:track:619OpJGKpAOrp5rM4Gcs65"]}
    scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "playlist-modify-public", "playlist-modify-private", "playlist-read-private"]
({
"snapshot_id": "MyxlMjg3ZGEyNWFlZjhmOTQxM2UzYzcxZTEzOTZkNWY4OGQ5M2M3NmU0"
}, 0)
```
"""
function playlist_add_tracks_to_playlist(playlist_id, track_uris; position = -1)
    method = "POST"
    u = "playlists/$playlist_id/tracks"
    a = urlstring(;position)
    url = build_query_string(u, a)
    body = bodystring(;uris = track_uris)
    spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end

# TODO playlist_reorder_or_replace_tracks()
## https://developer.spotify.com/documentation/web-api/reference/#/operations/reorder-or-replace-playlists-tracks

## https://developer.spotify.com/documentation/web-api/reference/#/operations/remove-tracks-playlist

"""
    playlist_remove_playlist_item(playlist_id; track_uris)

**Summary**: Remove one or more items from a user's playlist. For 'deleting playlists', see 'users_unfollow_artists_users'.

# Arguments
- `playlist_id` The Spotify ID of the playlist.
- `track_uris`   A maximum of 100 items can be removed in one request.

# Example (to be run after `playlist_create_playlist`)
```julia-repl
julia> playlist = ans
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 15 entries:
  :collaborative => false
  :description   => ""
  :external_urls => {…
  :followers     => {…
  ⋮              => ⋮

julia> track_uris = json.tracks.items .|> t -> t.track.uri
2-element Vector{String}:
 "spotify:track:1vMMlstAC32gQJSY20rKTI"
 "spotify:track:3bFoGv8y90y4fnaVwI3vSe"

julia> playlist_remove_playlist_item(playlist_id; track_uris)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :snapshot_id => "NCxhMmY2NzJhZWJiMTc4NjczNDUyY2E2ZjIyMTRjZTlmZjRlMTY2Nzll"
```
"""
function playlist_remove_playlist_item(playlist_id; track_uris)
    url = "playlists/$playlist_id/tracks"
    body = bodystring(;uris = track_uris)
    spotify_request(url, "DELETE"; body, scope= "playlist-modify-private")
end



## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-list-of-current-users-playlists
"""
    playlist_get_current_user(limit = 20, offset = 0)

**Summary**: Get a list of the playlists owned or followed by the current Spotify user.

# Optional keywords
- `limit`          : Maximum number of items to return, default is set to 20. Minimum: 1. Maximum: 50.
- `offset`         : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> playlist_get_current_user()[1]
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
function playlist_get_current_user(;limit = 20, offset = 0)
    u = "me/playlists"
    a = urlstring(;limit, offset)
    url = build_query_string(u, a)
    spotify_request(url;  scope = "playlist-read-private", additional_scope = "playlist-read-collaborative")
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-list-users-playlists
"""
playlist_get_user(user_id; limit = 20, offset = 0)

**Summary**: Get a list of the playlists owned or followed by a Spotify user.

# Arguments
- `user_id` : Alphanumeric ID of the user or name (e.g. "smedjan")

# Optional keywords
- `limit`          : Maximum number of items to return, default is set to 20
- `offset`         : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> playlist_get_user("smedjan")[1]
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
function playlist_get_user(user_id; limit = 20, offset = 0)
    u = "users/$user_id/playlists"
    a = urlstring(;limit, offset)
    url = build_query_string(u, a)
    spotify_request(url;  scope = "playlist-read-private", additional_scope = "playlist-read-collaborative")
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/create-playlist
"""
    playlist_create_playlist(name; user_id = SpUserId(), public = true, collaborative = false, description = "")

**Summary**: Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)

# Arguments
- `name` :   The name for the new playlist, for example "Your Coolest Playlist". This name does not need to be unique; a user may have several playlists with the same name.

# Optional keywords
- `user_id`                 Defaults to SpUserId(), from the .ini file
- `public`::Boolean         Defaults to true. If true the playlist will be public, if false it will be private. To be able to create private playlists, the user must have granted the playlist-modify-private scope
- `collaborative`::Boolean  Defaults to false. If true the playlist will be collaborative. Note: to create a collaborative playlist you must also set public to false. To create collaborative playlists you must have granted playlist-modify-private and playlist-modify-public scopes.
- `description`     Value for playlist description as displayed in Spotify Clients and in the Web API.

# Example
```
julia> user_id = get_user_name();

julia> description = "Songs about orcs learning to code after being laid off from the mines of Mordor";

julia> playlist_create_playlist("Temporary private playlist")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 15 entries:
  :collaborative => false
  :description   => nothing
  :external_urls => {…
  :followers     => {…
  :href          => "https://api.spotify.com/v1/playlists/6VX6WsbD9CpEGMAxuQEbm3"
  ⋮              => ⋮
```
"""
function playlist_create_playlist(name; user_id = SpUserId(), public = true, collaborative = false, description = "")
    method = "POST"
    url = "users/$user_id/playlists"
    body = bodystring(;name, description, public, collaborative)
   # body = """{"name": "$name", "description": "$description",  "public": $public, "collaborative": $collaborative}"""
    spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end



## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-featured-playlists
"""
    playlist_get_featured(;country = "", limit = 20, locale = "",
                               offset = 0, timestamp = "$(Dates.now())")

**Summary**: Get a list of Spotify featured playlists (shown, for example, on a Spotify player's 'Browse' tab).

# Optional keywords
- `country`       : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    If omitted, the returned items will be relevant to all countries.
- `limit`          : Maximum number of items to return, default is set to 20
- `locale`         : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
                    ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
                    Provide this parameter if you want the results returned in a particular language (where available).
                    Default is set to "en_US".
- `offset`         : Index of the first item to return, default is set to 0
- `timestamp` : A timestamp in ISO 8601 format: yyyy-MM-ddTHH:mm:ss. Use this parameter to specify the user's local time
                        to get results tailored for that specific date and time in the day.
                        Default is set to user's current time.

# Example
```julia-repl
julia> playlist_get_featured(locale = "en_UK")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 2 entries:
:message   => "Tuesday jams"
:playlists => {…
```
"""
function playlist_get_featured(;country = "", limit = 20, locale = "",
                               offset = 0, timestamp = "")
    assert_locale(locale)
    u = "browse/featured-playlists"
    a = urlstring(;country, limit, locale, offset, timestamp)
    url = build_query_string(u, a)                             
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-categories-playlists
"""
    playlist_get_category(category_id; country = "", limit = 20, offset = 0)

**Summary**: Get a list of Spotify playlists tagged with a particular category.

# Arguments
- `category_id`   : The unique string identifying the Spotify category, e.g. "dinner", "party" etc.

# Optional keywords
- `country`       : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    If omitted, the returned items will be relevant to all countries.
- `limit`         : Maximum number of items to return, default is set to 20
- `offset`        : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> playlist_get_category("party")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
:playlists => {…
```
"""
function playlist_get_category(category_id; country = "", limit = 20, offset = 0)
    u = "browse/categories/$category_id/playlists"
    a = urlstring(;country, limit, offset)
    url = build_query_string(u, a)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist-cover
"""
    playlist_get_cover_image(playlist_id)

**Summary**: Get the current image associated with a specific playlist.

# Arguments
- `playlist_id` : Alphanumeric ID of the playlist

# Example
```julia-repl
julia> playlist_get_cover_image("37i9dQZF1E4vUblDJbCkV3")[1]
1-element JSON3.Array{JSON3.Object, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
{
"height": nothing,
    "url": "https://seeded-session-images.scdn.co/v1/img/artist/6ltzsmQQbmdoHHbLZ4ZN25/en",
    "width": nothing
}
```
"""
function playlist_get_cover_image(playlist_id)
    spotify_request("playlists/$playlist_id/images")
end

# TODO playlist_upload_custom_cover()
## https://developer.spotify.com/documentation/web-api/reference/#/operations/upload-custom-playlist-cover