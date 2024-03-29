"""
    episodes_get_single(episode_id; market = get_user_country())

**Summary**: Get Spotify catalog information for a single episode identified by its unique Spotify ID.

# Arguments
- `episode_id` : The Spotify ID for the episode_id

# Optional keywords
- `market` : Default is `get_user_country()`.
             An ISO 3166-1 alpha-2 country code. If a country code is specified, only content
             that is available in that market will be returned. If a valid user access token
             is specified in the request header, the country associated with the user account
             will take priority over this parameter. Note: If neither market or user country
             are provided, the content is considered unavailable for the client.
             Users can view the country that is associated with their account in the account settings.

# Example
```julia-repl
julia> episodes_get_single("512ojhOuo1ktJprKbVcKyQ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 19 entries:
  :audio_preview_url    => "https://p.scdn.co/mp3-preview/566fcc94708f39bcddc09e4ce84a8e5db8f07d4d"
  :description          => "En ny tysk bok granskar för första gången Tredje rikets drogberoende, från Führerns k…
  :duration_ms          => 1502795
  :explicit             => false
  :external_urls        => {…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-episode)
"""
function episodes_get_single(episode_id; market = get_user_country())
    eid = SpEpisodeId(episode_id)
    u = "episodes/$eid"
    a = urlstring(;market)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-read-playback-position")
end


"""
    episodes_get_multiple(episode_ids; market = get_user_country())

**Summary**: Get Spotify catalog information for several episodes based on their Spotify IDs.

# Arguments
- `episode_ids` : A comma-separated list of the Spotify IDs for the episodes. Maximum: 50 IDs.

# Optional keywords
- `market` : Default: get_user_country().
             An ISO 3166-1 alpha-2 country code. If a country code is specified, only content
             that is available in that market will be returned. If a valid user access token
             is specified in the request header, the country associated with the user account
             will take priority over this parameter. Note: If neither market or user country
             are provided, the content is considered unavailable for the client.
             Users can view the country that is associated with their account in the account settings.

# Example
```julia-repl
julia> episodes_get_multiple(["77o6BIVlYM3msb4MMIL1jH", "0Q86acNRm6V9GYx55SXKwf"])[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :episodes => JSON3.Object[{…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-episodes)
"""
function episodes_get_multiple(episode_ids; market = get_user_country())
    eids = SpEpisodeId.(episode_ids)
    u = "episodes"
    a = urlstring(;ids = eids, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    episodes_get_saved(;limit = 20, market = "", offset = 0)

**Summary**: Get a list of the episodes saved in the current Spotify user's library.
             This API endpoint is in **beta** and could change without warning.

# Optional keywords
- `limit`  : Maximum number of items to return, default is set to 20
- `market` : An ISO 3166-1 alpha-2 country code. If a country code is specified, only content
             that is available in that market will be returned. If a valid user access token
             is specified in the request header, the country associated with the user account
             will take priority over this parameter. Note: If neither market or user country
             are provided, the content is considered unavailable for the client.
             Users can view the country that is associated with their account in the account settings.
- `offset` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> episodes_get_saved()[1]

JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/episodes?offset=0&limit=20&market=US"
  :items    => Union{}[]
  :limit    => 20

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-episodes)
"""
function episodes_get_saved(;limit = 20, market = "", offset = 0)
    u = "me/episodes"
    a = urlstring(;limit, market, offset)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read")
end


"""
    episodes_get_contains(episode_ids)

**Summary**: Check if one or more episodes is already saved in the current Spotify user's 'Your Episodes' library.
             This API endpoint is in **beta** and could change without warning.

# Arguments
- `ids` : A comma-separated list of the Spotify episode IDs

# Example
```julia-repl
julia> episodes_get_contains(["77o6BIVlYM3msb4MMIL1jH", "0Q86acNRm6V9GYx55SXKwf"])[1]

2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
 0
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-episodes)
"""
function episodes_get_contains(episode_ids)
    eids = SpEpisodeId.(episode_ids)
    u = "me/episodes/contains"
    a = urlstring(ids = eids)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read")
end