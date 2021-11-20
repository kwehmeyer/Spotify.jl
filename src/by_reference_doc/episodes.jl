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
julia> Spotify.episodes_get_single("512ojhOuo1ktJprKbVcKyQ")[1]
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
