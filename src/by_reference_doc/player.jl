## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-information-about-the-users-current-playback

"""
    player_get_state(;additional_types::String="track", market="")

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
"""
function player_get_state(;additional_types="track", market="")
    url = "me/player?additional_types=$additional_types"
    if market !== ""
        url *= "&market=$market"
    end
    spotify_request(url; scope = "user-read-playback-state")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-users-available-devices

"""
    player_get_devices()

**Summary**: Get information about a user’s available devices.

# Example
```julia-repl
julia> player_get_devices()[1]["devices"]
2-element JSON3.Array{JSON3.Object, Base.CodeUnits{UInt8, String}, SubArray{UInt64, 1, Vector{UInt64}, Tuple{UnitRange{Int64}}, true}}:
{
                   "id": "your_device_id",
            "is_active": false,
   "is_private_session": false,
        "is_restricted": false,
                 "name": "Web Player (Chrome)",
                 "type": "Computer",
       "volume_percent": 100
}
```
"""
function player_get_devices()

    spotify_request("me/player/devices"; scope = "user-read-playback-state")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-the-users-currently-playing-track

"""
    player_get_current_track(;additional_types="track", market="")

**Summary**: Get the object currently being played on the user's Spotify account.

# Optional keywords
- `additional_types::String` : "track" (default) or "episode"
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
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
"""
function player_get_current_track(;additional_types="track", market="")

    u = "me/player/currently-playing"
    a = urlstring(;additional_types, market)
    url = delimit(u, a)
    spotify_request(url; scope = "user-read-playback-state")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recently-played

"""
    player_get_recent_tracks(;duration::Int64=1, limit=20)

**Summary**: Get current user's recently played tracks.

# Optional keywords
- `duration::Int64` : Number of days to look in the past, default is set to 1
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
"""
function player_get_recent_tracks(;duration::Int64=1, limit=20)
    u = "me/player/recently-played"
    # Subtract duration from current date and convert to Int64
    starting_date = Dates.datetime2unix(Dates.now() - Dates.Day(duration))
    after = round(Int64, starting_date)
    a = urlstring(;after, limit)
    url = delimit(u, a)
    spotify_request(url; scope = "user-read-recently-played")
end


#https://developer.spotify.com/documentation/web-api/reference/#/operations/pause-a-users-playback
"""
    player_pause(;device_id="")

**Summary**: Pause playback on the user's account.

# Optional keywords

- `device_id`   The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
    Example value:
    "0d1841b0976bae2a3a310dd74c0f3df354899bc8"
"""
function player_pause(;device_id="")
    u = "me/player/pause"
    a = urlstring(;device_id)
    url = delimit(u, a)
    spotify_request(url, "PUT"; scope= "user-modify-playback-state")
end






#https://developer.spotify.com/documentation/web-api/reference/#/operations/start-a-users-playback
"""
    player_resume_playback(;device_id="", context_uri="", uris="", offset=0, position_ms=0)

**Summary**: Start a new context or resume current playback on the user's active device.

# Optional keywords
- `device_id`     The id of the device this command is targeting. If not supplied, the user's currently active device is the target. Example value:
"0d1841b0976bae2a3a310dd74c0f3df354899bc8"
- `context_uri`   Spotify URI of the context to play. Valid contexts are albums, artists & playlists. {context_uri:"spotify:album:1Je1IMUlBXcx1Fz0WE7oPT"}
- `uris`          Array of strings. This is formed to JSON locally.
- `offset`        Indicates from where in the context playback should start. Only available when context_uri corresponds to an album or playlist object 
    "position" is zero based and can’t be negative. Example: "offset": {"position": 5} "uri" is a string representing the uri of the item to start at. 
                  Example: "offset": {"uri": "spotify:track:1301WleyT98MSxVHPZCA6M"}
- `position_ms`   Integer

# Examples

```julia-repl
julia> player_resume_playback(uris= [\"spotify:track:4iV5W9uYEdYUVa79Axb7Rh\", \"spotify:track:1301WleyT98MSxVHPZCA6M\"])
```
... which is equivalent to this more formal input style:

```julia-repl
julia> sids = ["4iV5W9uYEdYUVa79Axb7Rh", "1301WleyT98MSxVHPZCA6M"];

julia> uris = SpUri.(sids);

julia> player_resume_playback(; uris)
    PUT https://api.spotify.com/v1/me/player/play/?   \\{"uris": ["spotify:track:4iV5W9uYEdYUVa79Axb7Rh", "spotify:track:1301WleyT98MSxVHPZCA6M"]}
    scopes in current credentials: ["user-read-private", "user-read-email", "user-follow-read", "user-library-read", "user-read-playback-state", "user-read-recently-played", "user-top-read", "user-modify-playback-state"]
[ Info: 204: No Content - The request has succeeded but returns no message body.
({}, 0)
```

Single tracks must also be enclosed in vector brackets:

```julia-repl
player_resume_playback(; uris = [SpUri("2knANHszLdV409tIWivfVR")])
```
"""
function player_resume_playback(;device_id="", context_uri="", uris="", offset=0, position_ms=0)
    u = "me/player/play"
    a = urlstring(;device_id)
    url = delimit(u, a)
    body = bodystring(;context_uri, uris, offset, position_ms)
    spotify_request(url, "PUT"; body, scope= "user-modify-playback-state")
end

#https://developer.spotify.com/documentation/web-api/reference/#/operations/skip-users-playback-to-next-track
"""
    player_skip_to_next(;device_id = "")

**Summary**: Skips to next track in the user’s queue.

- device_id    The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
"""
function player_skip_to_next(;device_id = "")
    u = "me/player/next"
    a = urlstring(;device_id)
    url = delimit(u, a)
    body = bodystring(;)
    spotify_request(url, "POST"; body, scope = "user-modify-playback-state")
end


# https://developer.spotify.com/documentation/web-api/reference/#/operations/skip-users-playback-to-previous-track
"""
    player_skip_to_previous(;device_id = "")

**Summary**: Skips to previous track in the user’s queue.

- device_id    The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
"""
function player_skip_to_previous(;device_id = "")
    u = "me/player/previous"
    a = urlstring(;device_id)
    url = delimit(u, a)
    body = bodystring(;)
    spotify_request(url, "POST"; body, scope = "user-modify-playback-state")
end

