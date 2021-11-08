## https://developer.spotify.com/documentation/web-api/reference/#/operations/search

"""
    search_get(;q::String="Coldplay", item_type::String="track,artist", include_external::String="",
                    limit::Int64=20, market::String="US", offset::Int64=0)

**Summary**: Get Spotify catalog information about albums, artists, playlists, tracks, 
             shows or episodes that match a keyword string.

# Optional keywords
- `q::String` : Search query, e.g. "Coldplay" which is also set as the default
- `item_type::String` : A comma-separated list of item types to search across. Search results include 
                   hits from all the specified item types. For example, item_type = "album,tarck" returns 
                   both albums and tracks with the search query included in their name.
- `include_external::String` : If include_external="audio" is specified then the response will include any 
                               relevant audio content that is hosted externally.
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified, 
                        only episodes that are available in that market will be returned. 
                        Default is set to "US".
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> Spotify.search_get(;q = "Greenday", item_type = "album")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :albums => {…
```
"""
function search_get(;q::String="Coldplay", item_type::String="track,artist", include_external::String="",
                    limit::Int64=20, market::String="US", offset::Int64=0)

    url1 = "search?q=$q&type=$item_type&include_external=$include_external"
    url2 = "&limit=$limit&market=$market&offset=$offset"

    return Spotify.spotify_request(url1 * url2)

end

