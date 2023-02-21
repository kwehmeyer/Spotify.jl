"""
    player_get_state(;additional_types = "track", market = "")

**Summary**: Get information about the user’s current playback state, including track or episode,
             progress, and active device.

# Optional keywords
- `additional_types` : "track" (default) or "episode"
- `market`           : An ISO 3166-1 alpha-2 country code. If a country code is specified, only content
                       that is available in that market will be returned. If a valid user access token
                       is specified in the request header, the country associated with the user account
                       will take priority over this parameter. Note: If neither market or user country
                      are provided, the content is considered unavailable for the client.  Users can
                      view the country that is associated with their account in the account settings.
                      NOTE: Default is set to "".

# Example
```julia-repl
julia> player_get_state()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 10 entries:
  :device                 => {…
  :shuffle_state          => false
  :repeat_state           => "off"
  :timestamp              => 1636493367689
  :context                => {…
  :progress_ms            => 66454
  :item                   => {…
  :currently_playing_type => "track"
  :actions                => {…
  :is_playing             => true
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-information-about-the-users-current-playback)
"""
function player_get_state(;additional_types = "track", market = "")
    u = "me/player"
    a = urlstring(;additional_types, market)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-read-playback-state")
end


"""
    player_get_devices()

**Summary**: Get information about a user’s available devices.

# Example
```julia-repl
julia> player_get_devices()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :devices => JSON3.Object[{…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-users-available-devices)
"""
function player_get_devices()
    spotify_request("me/player/devices"; scope = "user-read-playback-state")
end


"""
    player_get_current_track(;additional_types = "track", market = "")

**Summary**: Get the object currently being played on the user's Spotify account.

# Optional keywords
- `additional_types` : "track" (default) or "episode"
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".

# Example
```julia-repl
julia> player_get_current_track()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :timestamp              => 1636491068506
  :context                => {…
  :progress_ms            => 5265
  :item                   => {…
  :currently_playing_type => "track"
  :actions                => {…
  :is_playing             => true
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-the-users-currently-playing-track)
"""
function player_get_current_track(;additional_types = "track", market = "")
    u = "me/player/currently-playing"
    a = urlstring(;additional_types, market)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-read-playback-state")
end


"""
    player_get_recent_tracks(;duration = 1, limit = 20)

**Summary**: Get current user's recently played tracks.

# Optional keywords
- `duration` : Number of days to look in the past, default is set to 1
- `limit` : Maximum number of items to return, default is set to 20

# Example
```julia-repl
julia> player_get_recent_tracks()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 5 entries:
  :items   => JSON3.Object[{…
  :next    => "https://api.spotify.com/v1/me/player/recently-played?after=1636123644988&limit=20"
  :cursors => {…
  :limit   => 20
  :href    => "https://api.spotify.com/v1/me/player/recently-played?after=1636410050&limit=20"
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recently-played)
"""
function player_get_recent_tracks(;duration = 1, limit = 20)
    u = "me/player/recently-played"
    # Subtract duration from current date and convert to Int64
    starting_date = Dates.datetime2unix(Dates.now() - Dates.Day(duration))
    after = round(Int64, starting_date)
    a = urlstring(;after, limit)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-read-recently-played")
end


"""
    player_pause(;device_id = "")

**Summary**: Pause playback on the user's account.

# Optional keywords

- `device_id`   The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
    Example value:
    "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

# Example

```julia-repl
julia> device_id = player_get_devices()[1].devices[1].id;

julia> player_pause(;device_id)
({}, 0)

julia> player_pause() # Fails because we already paused, see `player_resume_playback`
┌ Info: 403 (code meaning): Forbidden - The server understood the request, but is refusing to fulfill it.
└               (response message): Player command failed: Restriction violated
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/pause-a-users-playback)
"""
function player_pause(;device_id = "")
    u = "me/player/pause"
    a = urlstring(;device_id)
    url = build_query_string(u, a)
    spotify_request(url, "PUT"; scope= "user-modify-playback-state")
end


"""
    player_resume_playback(;device_id = "", context_uri = "", uris = "", offset = 0, position_ms = 0)

**Summary**: Start a new context or resume current playback on the user's active device.

# Optional keywords
- `device_id`     The id of the device this command is targeting. If not supplied, the user's currently active device is the target. Example value:
"0d1841b0976bae2a3a310dd74c0f3df354899bc8"
- `context_uri`   Spotify URI of the context to play. Valid contexts are albums, artists & playlists. {context_uri:"spotify:album:1Je1IMUlBXcx1Fz0WE7oPT"}
- `uris`          Vector of arguments to (queue and) play. Accepts string types (with prefixes like 'spotify:track:') or types like SpTrackId, SpEpisodeId.
- `offset`        Indicates from where in the context playback should start. Only available when context_uri corresponds to an album or playlist object
    "position" is zero based and can’t be negative. Example: "offset": {"position": 5} "uri" is a string representing the uri of the item to start at.
                  Example: "offset": {"uri": "spotify:track:1301WleyT98MSxVHPZCA6M"}
- `position_ms`   Integer

# Examples

```julia-repl
julia> context_uri = SpAlbumId("1XORY4rQNhqkZxTze6Px90")
spotify:album:1XORY4rQNhqkZxTze6Px90

julia> offset = Dict("position" => 35) # Song no.
Dict{String, Int64} with 1 entry:
  "position" => 35
julia> position_ms = 59000
59000
julia> player_resume_playback(;context_uri, offset, position_ms)[1]
{}
```
We can alternatively specify a sequence of tracks, here no. 1 and 35 from the same album.
We can set the starting position for the first of those:

```julia-repl
julia> uris = SpTrackId.(["4SFBV7SRNG2e2kyL1F6kjU", "46J1vycWdEZPkSbWUdwMZQ"])
2-element Vector{SpTrackId}:
 spotify:track:4SFBV7SRNG2e2kyL1F6kjU
 spotify:track:46J1vycWdEZPkSbWUdwMZQ

julia> player_resume_playback(;uris, position_ms = 82000)[1]
{}

```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/start-a-users-playback)
"""
function player_resume_playback(;device_id = "", context_uri::S = "", uris::T = "", offset = 0, position_ms = 0) where {S, T}
    u = "me/player/play"
    a = urlstring(;device_id)
    url = build_query_string(u, a)
    if ! (T  <: Union{AbstractString, Vector{String}, Vector{SpTrackId}, Vector{SpEpisodeId}})
        @warn "unexpected uris argument: $T"
    end
    if ! (S  <: Union{AbstractString, SpAlbumId, SpArtistId, SpPlaylistId})
        @warn "unexpected context_uri argument: $S"
    end
    body = body_string(;context_uri, uris, offset, position_ms)
    spotify_request(url, "PUT"; body, scope= "user-modify-playback-state")
end


"""
    player_skip_to_next(;device_id = "")

**Summary**: Skips to next track in the user’s queue.

- device_id    The id of the device this command is targeting. If not supplied, the user's currently active device is the target.

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/skip-users-playback-to-next-track)
"""
function player_skip_to_next(;device_id = "")
    u = "me/player/next"
    a = urlstring(;device_id)
    url = build_query_string(u, a)
    spotify_request(url, "POST"; scope = "user-modify-playback-state")
end


"""
    player_skip_to_previous(;device_id = "")

**Summary**: Skips to previous track in the user’s queue.

- device_id    The id of the device this command is targeting. If not supplied, the user's currently active device is the target.

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/skip-users-playback-to-previous-track)
"""
function player_skip_to_previous(;device_id = "")
    u = "me/player/previous"
    a = urlstring(;device_id)
    url = build_query_string(u, a)
    spotify_request(url, "POST"; scope = "user-modify-playback-state")
end

