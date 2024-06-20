"""
    playlist_get(playlist_id; additional_types = "track", fields = "",
    market = "")

  **Summary**: Get details about a playlist owned by a Spotify user. 
      NOTE 1: For private playlists with > 100 tracks, use `playlist_get_tracks` instead.
      NOTE 2: For public playlists with > 50 tracks, don't expect to see beyound 50.

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

  This works with severe limitations to the number of tracks returned.

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

    # Example, general use

    ```julia-repl
    julia> @time let
        playlist_id = SpPlaylistId("37i9dQZF1E4vUblDJbCkV3") # public, meets limitations.
        playlist_id = SpPlaylistId("3FyJWXqFocKq2SYGjGoelU") # private, this works with up to 100 tracks.
        fields = "name,tracks(total)"
        pll = playlist_get(playlist_id; fields)[1];
        # This returns 50 in longer playlists, except when the playlist is your own.
        ntot = pll.tracks.total  
        if ntot < 101
            println("Retrieving all ", ntot, " tracks from ", pll.name)
        else
            println("Unable to retrieva all ", ntot, " tracks. Refer to `playlist_get_tracks`")
        end
        # We unnecessarily limit the data returned here. It does not help with the upper limit.
        fields = "tracks(items(track(id,name)),next)"
        o, waitsec = playlist_get(playlist_id; fields);
        track_names = o.tracks.items .|> i -> i.track.name |> string
        track_ids = o.tracks.items .|> i -> i.track.id |> SpTrackId
    end;
    Unable to retrieva all 529 tracks. Refer to `playlist_get_tracks`
  0.837955 seconds (612.52 k allocations: 30.531 MiB, 1.90% gc time, 17.00% compilation time)
    ```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist)
"""
function playlist_get(playlist_id; additional_types = "track", fields = "",
                      market = "")
    pli = SpPlaylistId(playlist_id)
    u = "playlists/$pli"
    a  = urlstring(;additional_types, fields, market)
    url = build_query_string(u, a)
    spotify_request(url, scope = "playlist-read-private", additional_scope = "playlist-read-collaborative")
end


"""

**Summary**: Change a playlist's name and public/private state. (The user must, of course, own the playlist.)

# Arguments
- `playlist_id`   : Alphanumeric ID of the playlist

# Optional keywords

- `name`           The new name for the playlist. Default: Argument not sent.
- `public`         If true the playlist will be public, if false it will be private. Default: Argument not sent.
- `collaborative`  If true, the playlist will become collaborative and other users will be able to modify the playlist in their Spotify client.
                   Note: You can only set collaborative to true on non-public playlists. Default: Argument not sent.
- `description`    Value for playlist description as displayed in Spotify Clients and in the Web API. Default: Argument not sent.

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/change-playlist-details)
"""
function playlist_change_details(playlist_id; name = "", public = "", collaborative = "", description = "")
    method = "PUT"
    if name == "" && public == "" && collaborative == "" && description == ""
        @warn "At least one keyword argument must be given: name, public, collaborative or description"
        return JSON3.Object(), 0
    end
    pli = SpPlaylistId(playlist_id)
    url = "playlists/$pli"
    body = body_string(;name, public, collaborative, description)
    spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end

"""
    playlist_get_tracks(playlist_id; additional_types = "track", limit = 50,
    offset = 0, market = "")

**Summary**: Get details about the items of a playlist. NOTE: requires several calls for long lists.

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

For fewer than 21 tracks:
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

# Example, general use

For longer playlists, we should ask for the fields we need only. The rate limits should be returned in 'waitsec', but this
does not seem to work as documented  with long playlists not owned by user.

```julia-repl
julia> @time let
    playlist_id = SpPlaylistId("37i9dQZF1E4vUblDJbCkV3") # public, meets limitations at 50 items.
    playlist_id = SpPlaylistId("3FyJWXqFocKq2SYGjGoelU") # private, this works well.
    fields = "name,tracks(total)"
    pll = playlist_get(playlist_id; fields)[1];
    ntot = pll.tracks.total
    println("Retrieving all ", ntot, " tracks from ", pll.name)
    fields = "items(track(name,id)),total, next"
    o, waitsec = playlist_get_tracks(playlist_id; fields, limit=100);
    track_ids = o.items .|> i -> i.track.id |> SpTrackId
    while o.next !== nothing
        if waitsec > 0
            println("waiting ", waitsec, " s")
            sleep(waitsec)
        else
            print(".")
        end
        o, waitsec = playlist_get_tracks(playlist_id; offset = length(track_ids), fields, limit=100);
        append!(track_ids, o.items .|> i -> i.track.id |> SpTrackId)
    end
    println("Found ", length(track_ids), " tracks")
    track_ids
end;
Retrieving all 529 tracks from -- Liked from Radio --
.....Found 529 tracks
  2.669471 seconds (645.63 k allocations: 32.448 MiB, 4.26% compilation time)
```
[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks)
"""
function playlist_get_tracks(playlist_id; additional_types = "track", fields = "",
                             limit = 20, offset = 0, market = "")
    pli = SpPlaylistId(playlist_id)
    u = "playlists/$pli/tracks"
    a = urlstring(;additional_types, fields, limit, offset, market)
    url = build_query_string(u, a)
    spotify_request(url; scope = "playlist-read-private", additional_scope = "playlist-read-collaborative")
end


"""
    playlist_add_tracks_to_playlist(playlist_id, track_ids; position = -1)

**Summary**: Add one or more items to a user's playlist.

# Arguments
- `playlist_id`:  The Spotify ID of the playlist.
- `track_ids`:   A maximum of 100 items can be added in one request.
# Optional keywords
- `position`:     The position to insert the items, a zero-based index.
    For example, to insert the items in the first position: position = 0;
    to insert the items in the third position: position = 2.
    The default value is -1, meaning we omit the argument in the API call.
    When omitted, the items will be appended to the playlist. Items are added in the order they
    are listed in the query string or request body.

# Example (continued from `playlist_create_playlist`)
```julia-repl
julia> track_ids = SpTrackId.(["4m6P9J3czb5hiMIuNsWeVO", "619OpJGKpAOrp5rM4Gcs65"])
2-element Vector{SpTrackId}:
 spotify:track:4m6P9J3czb5hiMIuNsWeVO
 spotify:track:619OpJGKpAOrp5rM4Gcs65

julia> playlist_add_tracks_to_playlist(myownplaylistid, track_ids)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :snapshot_id => "Myw3OTkwNGExNzExNjA2ZWRhMDBkYjgwOWEwNzgzNGY2ZTRiODU3ZTkz"

julia> # Cleanup: See `playlist_remove_playlist_item`
```

Or, for one of your own playlists,
```julia-repl
julia> function get_my_own_playlist()
            pls = playlist_get_current_user()[1]
            for p in pls.items
                if p.owner.id == Spotify.get_user_name()
                    return p
                end
            end
            nothing
        end
julia> myownplaylistid = get_my_own_playlist().id |> SpPlaylistId
spotify:playlist:6VX6WsbD9CpEGMAxuQEbm3

julia> track_ids = SpTrackId.(["4m6P9J3czb5hiMIuNsWeVO", "619OpJGKpAOrp5rM4Gcs65"]);

julia> playlist_add_tracks_to_playlist(myownplaylistid, track_ids)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :snapshot_id => "MTEsOWE1MjA0M2IxMDlhYjFjM2M2OGE0YTBlOWM4MTY1OGVjYWU2NWQxMw=="

julia> # Cleanup: See `playlist_remove_playlist_item`
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/add-tracks-to-playlist)
"""
function playlist_add_tracks_to_playlist(playlist_id, track_ids; position = -1)
    method = "POST"
    pli = SpPlaylistId(playlist_id)
    u = "playlists/$pli/tracks"
    a = urlstring(;position)
    url = build_query_string(u, a)
    uris = SpTrackId.(track_ids)
    body = body_string(;uris)
    spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end


"""
    playlist_remove_playlist_item(playlist_id, track_ids)

**Summary**: Remove one or more items from a user's playlist. For 'deleting playlists', see 'users_unfollow_artists_users'.

# Arguments
- `playlist_id` The Spotify ID of the playlist.
- `track_ids`   A maximum of 100 items can be removed in one request.

# Example (to be run after examples in `playlist_create_playlist` and `playlist_add_tracks_to_playlist`.
```julia-repl
julia> playlist_remove_playlist_item(myownplaylistid, track_ids)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :snapshot_id => "NCwwNWI4YjdjODk5OWI1MGRlZTIzYjdjYzY4ZDhkMzczZDMyYzQ1YTRl"

julia> # Cleanup: This example is continued under `Spotify.Users.users_unfollow_playlist`.
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/remove-tracks-playlist)
"""
function playlist_remove_playlist_item(playlist_id, track_ids)
    method = "DELETE"
    pli = SpPlaylistId(playlist_id)
    url = "playlists/$pli/tracks"
    uris = SpTrackId.(track_ids)
    tracks = ["uri"=>uri for uri in uris]
    body = body_string(;tracks)
    spotify_request(url, method; body, scope= "playlist-modify-private")
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-list-of-current-users-playlists)
"""
function playlist_get_current_user(;limit = 20, offset = 0)
    u = "me/playlists"
    a = urlstring(;limit, offset)
    url = build_query_string(u, a)
    spotify_request(url;  scope = "playlist-read-private", additional_scope = "playlist-read-collaborative")
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-list-users-playlists)
"""
function playlist_get_user(user_id; limit = 20, offset = 0)
    u = "users/$user_id/playlists"
    a = urlstring(;limit, offset)
    url = build_query_string(u, a)
    spotify_request(url;  scope = "playlist-read-private", additional_scope = "playlist-read-collaborative")
end


"""
    playlist_create_playlist(playlist_name; user_id = get_user_name(), public = true, collaborative = false, description = "")

**Summary**: Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)

# Arguments
- `playlist_name` :   The name for the new playlist, for example "Your Coolest Playlist". This name does not need to be unique; a user may have several playlists with the same name.

# Optional keywords
- `user_id`                 Defaults to get_user_name(), from the .ini file
- `public`::Boolean         Defaults to true. If true the playlist will be public, if false it will be private. To be able to create private playlists, the user must have granted the playlist-modify-private scope
- `collaborative`::Boolean  Defaults to false. If true the playlist will be collaborative. Note: to create a collaborative playlist you must also set public to false. To create collaborative playlists you must have granted playlist-modify-private and playlist-modify-public scopes.
- `description`     Value for playlist description as displayed in Spotify Clients and in the Web API.

# Example
```
julia> description = "Songs about orcs learning to code after being laid off from the mines of Mordor";

julia> playlist = playlist_create_playlist("Temporary private playlist"; description)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 15 entries:
  :collaborative => false
  :description   => nothing
  :external_urls => {…
  :followers     => {…
  :href          => "https://api.spotify.com/v1/playlists/6VX6WsbD9CpEGMAxuQEbm3"
  ⋮              => ⋮

julia> myownplaylistid = playlist.id |> SpPlaylistId
spotify:playlist:0akFdMBfiqbkAUSY5hTYKs

julia> # Cleanup: See `playlist_add_tracks_to_playlist`, or skip straight to `Spotify.Users.users_unfollow_playlist`
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/create-playlist)
"""
function playlist_create_playlist(playlist_name; user_id = get_user_name(), public = true, collaborative = false, description = "")
    method = "POST"
    url = "users/$user_id/playlists"
    body = body_string(;name = playlist_name, description, public, collaborative)
    spotify_request(url, method; body,
        scope = "playlist-modify-public",
        additional_scope = "playlist-modify-private")
end


"""
    playlist_get_featured(;country = "", limit = 20, locale = "",
                               offset = 0, timestamp = now())

**Summary**: Get a list of Spotify featured playlists (shown, for example, on a Spotify player's 'Browse' tab).

# Optional keywords
- `country`       : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    If omitted, the returned items will be relevant to all countries.
- `limit`          : Maximum number of items to return, default is set to 20
- `locale`         : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
                    ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
                    Provide this parameter if you want the results returned in a particular language (where available).
- `offset`         : Index of the first item to return, default is set to 0
- `timestamp`      : A timestamp in ISO 8601 format: yyyy-MM-ddTHH:mm:ss. Use this parameter to specify the user's local time
                     to get results tailored for that specific date and time in the day. Default is set to user's current time.

# Example
```julia-repl
julia> playlist_get_featured(locale = "en_UK")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 2 entries:
:message   => "Tuesday jams"
:playlists => {…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-featured-playlists)
"""
function playlist_get_featured(;country = "", limit = 20, locale = "",
                               offset = 0, timestamp = now())
    assert_locale(locale)
    u = "browse/featured-playlists"
    a = urlstring(;country, limit, locale, offset, timestamp)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    playlist_get_category(category_name; country = "", limit = 20, offset = 0)

**Summary**: Get a list of Spotify playlists tagged with a particular category.

# Arguments
- `category_name`   : The unique string identifying the Spotify category, e.g. "dinner", "party" etc.

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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-categories-playlists)
"""
function playlist_get_category(category_name; country = "", limit = 20, offset = 0)
    u = "browse/categories/$category_name/playlists"
    a = urlstring(;country, limit, offset)
    url = build_query_string(u, a)
    spotify_request(url)
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist-cover)
"""
function playlist_get_cover_image(playlist_id)
    pli = SpPlaylistId(playlist_id)
    spotify_request("playlists/$pli/images")
end

# TODO playlist_upload_custom_cover()
## https://developer.spotify.com/documentation/web-api/reference/#/operations/upload-custom-playlist-cover
