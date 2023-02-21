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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artist)
"""
function artist_get(artist_id)
    arid = SpArtistId(artist_id)
    spotify_request("artists/$arid")
end


"""
    artist_get_albums(artist_id; include_groups = "album", country = "", limit = 20, offset = 0)

**Summary**: Get Spotify catalog information about an artist's albums.

# Arguments
- `artist_id` : The Spotify ID of the artist

# Optional keyword arguments
- `include_groups` : A comma-separated list of keywords that will be used to filter the response.
                     If not supplied, all album types will be returned.
                     Valid values are:
                     * `album`
                     * `single`
                     * `compilation`
                     * `appears_on`
- `country`        : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                     the list of returned items to be relevant to a particular country.
                     If omitted, the returned items will be relevant to all countries.
- `limit` : The maximum number of tracks to return. Default is set to 20.
- `offset` : The index of the first track to return. Default is 0.

# Example
```julia-repl
julia> artist_get_albums("0YC192cP3KPCRWx8zr8MfZ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 10 entries:
  :external_urls => {…
  :followers     => {…
  :genres        => ["german soundtrack", "orchestral soundtrack", "soundtrack"]
  :href          => "https://api.spotify.com/v1/artists/0YC192cP3KPCRWx8zr8MfZ"
  :id            => "0YC192cP3KPCRWx8zr8MfZ"
  :images        => JSON3.Object[{…
  :name          => "Hans Zimmer"
  :popularity    => 79
  ⋮              => ⋮
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums)
"""
function artist_get_albums(artist_id; include_groups = "", country = "", limit = 20, offset = 0)
    arid = SpArtistId(artist_id)
    u = "artists/$arid"
    a = urlstring(; include_groups, country, limit, offset)
    url = build_query_string(u, a)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-top-tracks

"""
    artist_top_tracks(artist_id; market = get_user_country())

**Summary**: Get Spotify catalog information about an artist's top tracks by country.

# Arguments
- `artist_id` : The Spotify ID of the artist

# Optional keyword arguments
- `market`       : Default is `get_user_country()`.
                   An ISO 3166-1 alpha-2 country code. If a country code is specified, only content that is
                   available in that market will be returned. If a valid user access token is specified in
                   the request header, the country associated with the user account will take priority over
                   this parameter.

                   API note: "If neither market or user country are provided, the content is considered unavailable
                   for the client. Users can view the country that is associated with their account in the
                   account settings."

                   Spotify.jl note: If no market is specified, we unexpectedly get 'missing country parameter'.
                   We do not want this behaviour to be general for all calls with an optional "market" argument.
                   A default 'market = ""' is acceptable for all (?) other API calls with 'market'.

# Example
```julia-repl
julia> artist_top_tracks("0YC192cP3KPCRWx8zr8MfZ")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :tracks => JSON3.Object[{…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums)
"""
function artist_top_tracks(artist_id; market = get_user_country())
    arid = SpArtistId(artist_id)
    u = "artists/$arid/top-tracks"
    a = urlstring(;market)
    url = build_query_string(u, a)
    spotify_request(url)
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-related-artists)
"""
function artist_get_related_artists(artist_id)
    arid = SpArtistId(artist_id)
    spotify_request("artists/$arid/related-artists")
end