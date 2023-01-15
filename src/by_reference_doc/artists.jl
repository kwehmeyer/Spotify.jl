## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artist

"""
    artist_get(artist_id)

**Summary**: Get Spotify catalog information for a single artist identified by their unique Spotify ID.

# Arguments
- `artist_id` : The Spotify artist ID.

# Example
```julia-repl
julia> artist_get("0YC192cP3KPCRWx8zr8MfZ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 10 entries:
  :external_urls => {…
  :followers     => {…
  :genres        => ["german soundtrack", "soundtrack"]
  :href          => "https://api.spotify.com/v1/artists/0YC192cP3KPCRWx8zr8MfZ"
```
"""
function artist_get(artist_id)
    return spotify_request("artists/$artist_id")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums

"""
    artist_get_albums(artist_id; include_groups="None", country="US", limit=20, offset=0)

**Summary**: Get Spotify catalog information about an artist's albums.

# Arguments
- `artist_id` : The Spotify ID of the artist

# Optional keywords
- `include_groups` : A comma-separated list of keywords that will be used to filter the response.
                     If not supplied, all album types will be returned.
                     Valid values are:
                     * `album`
                     * `single`
                     * `compilation`
                     * `appears_on`
- `country` : An ISO 3166-1 alpha-2 country code string. Use this to limit the response to one particular
              geographical market. Default is set to "US".
- `limit` : The maximum number of tracks to return. Default is set to 20.
- `offset` : The index of the first track to return. Default is 0.

# Example
```julia-repl
julia> artist_get_albums("0YC192cP3KPCRWx8zr8MfZ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 10 entries:
  :external_urls => {…
  :followers     => {…
  :genres        => ["german soundtrack", "soundtrack"]
  :href          => "https://api.spotify.com/v1/artists/0YC192cP3KPCRWx8zr8MfZ"
```
"""
function artist_get_albums(artist_id; include_groups="album", country="US", limit=20, offset=0)

    url1 = "artists/$artist_id?include_groups=$include_groups"
    url2 = "&country=$country&limit=$limit&offset=$offset"

    return spotify_request(url1 * url2)

end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-top-tracks

"""
    artist_top_tracks(artist_id; country="US")

**Summary**: Get Spotify catalog information about an artist's top tracks by country.

# Arguments
- `artist_id` : The Spotify ID of the artist

# Optional keywords
- `country` : An ISO 3166-1 alpha-2 country code string. Use this to limit the response to one particular
              geographical market. Default is set to "US".

# Example
```julia-repl
julia> artist_top_tracks("0YC192cP3KPCRWx8zr8MfZ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :tracks => JSON3.Object[{…
```
"""
function artist_top_tracks(artist_id; country="US")
    return spotify_request("artists/$artist_id/top-tracks?country=$country")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-related-artists
"""
artist_get_related_artists(artist_id)

**Summary**: Get spotify catalog information about artists similar to a given artist.
            Similarity is based on analysis of the Spotify community's listening history.

# Arguments
- `artist_id` : The Spotify ID of the artist

# Example
```julia-repl
julia> artist_get_related_artists("0YC192cP3KPCRWx8zr8MfZ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
:artists => JSON3.Object[{…
```
"""
function artist_get_related_artists(artist_id)
    return spotify_request("artists/$artist_id/related-artists")
end