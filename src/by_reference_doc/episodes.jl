## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-episode

"""
    episodes_get_single(episode_id; market="US")

**Summary**: Get Spotify catalog information for a single episode identified by its unique Spotify ID.

# Arguments
- `episode_id` : The Spotify ID for the episode_id

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

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
"""
function episodes_get_single(episode_id; market="US")
    return spotify_request("episodes/$episode_id?market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-episodes

"""
    episodes_get_multiple(episode_ids; market="US")

**Summary**: Get Spotify catalog information for several episodes based on their Spotify IDs.

# Arguments
- `episode_ids` : A comma-separated list of the Spotify IDs for the episodes. Maximum: 50 IDs.

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> episodes_get_multiple("77o6BIVlYM3msb4MMIL1jH,0Q86acNRm6V9GYx55SXKwf")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :episodes => JSON3.Object[{…
```
"""
function episodes_get_multiple(episode_ids; market="US")
    return spotify_request("episodes?ids=$episode_ids&market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-episodes

"""
    episodes_get_saved(;limit=20, market="", offset::Int64=0)

**Summary**: Get a list of the episodes saved in the current Spotify user's library.
             This API endpoint is in **beta** and could change without warning.

# Optional keywords
- `limit`          : Maximum number of items to return, default is set to 20
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> episodes_get_saved()[1]

JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/episodes?offset=0&limit=20&market=US"
  :items    => Union{}[]
  :limit    => 20
"""
function episodes_get_saved(;limit=20, market="", offset::Int64=0)

    return spotify_request("me/episodes?limit=$limit&market=$market&offset=$offset";
    scope = "user-library-read")

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-episodes

"""
    episodes_get_contains(ids)

**Summary**: Check if one or more episodes is already saved in the current Spotify user's 'Your Episodes' library.
             This API endpoint is in **beta** and could change without warning.

# Arguments
- `ids` : A comma-separated list of the Spotify episode IDs

# Example
```julia-repl
julia> episodes_get_contains("77o6BIVlYM3msb4MMIL1jH,0Q86acNRm6V9GYx55SXKwf")[1]

2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
 0
```
"""
function episodes_get_contains(ids)
    return spotify_request("me/episodes/contains?ids=$ids"; scope = "user-library-read")
end