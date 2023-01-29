## https://developer.spotify.com/documentation/web-api/reference/#/operations/search

"""
    search_get(q; item_type = "track,artist", include_external = "",
                    limit = 20, market = "", offset = 0)

**Summary**: Get Spotify catalog information about albums, artists, playlists, tracks,
             shows or episodes that match a keyword string. Note: Audiobooks are only 
             available for the US, UK, Ireland, New Zealand and Australia markets.

# Arguments
- `q`                 : Search query, e.g. "Coldplay".

# Optional keywords
- `item_type` : A comma-separated list of item types to search across. Search results include
                   hits from all the specified item types. For example, item_type = "album,tarck" returns
                   both albums and tracks with the search query included in their name.
- `include_external` : If include_external = "audio" is specified then the response will include any
                               relevant audio content that is hosted externally.
- `limit`          : Maximum number of items to return, default is set to 20
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                        only episodes that are available in that market will be returned.
                        Default is set to "US".
- `offset`         : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> search_get("Coldplay")[1]
     GET https://api.spotify.com/v1/search?q=Coldplay&type=track,artist&include_external=&limit=20&market=US&offset=0
     scopes in current credentials: String[]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 2 entries:
  :artists => {…
  :tracks  => {…
```
"""
function search_get(q; item_type = "track,artist", include_external = "",
                    limit = 20, market = "", offset = 0)

    url1 = "search?q=$q&type=$item_type&include_external=$include_external"
    url2 = "&limit=$limit&market=$market&offset=$offset"

    spotify_request(url1 * url2)

end

