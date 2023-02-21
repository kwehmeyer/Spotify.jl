"""
    album_get_single(album_id; market = "")

    **Summary**: Get Spotify catalog information for a single album.

    # Arguments
    - `album_id` : The Spotify ID for the album.

    # Optional keywords
    - `market` : An ISO 3166-1 alpha-2 country code.

    # Example
    ```julia-repl
    julia> album_get_single("2O9mD7oKwBnhQZQUAJM6GM")[1]
    JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 19 entries:
      :album_type             => "album"
      :artists                => JSON3.Object[{…
      :available_markets      => ["AD", "AE", "AR", "AT", "AU", "BD", "BE", "BG", "BH", "BO"  …  "SK", "SV", "TH", "TN", "T…
      :copyrights             => JSON3.Object[{…
      :external_ids           => {…
      :external_urls          => {…
      :genres                 => Union{}[]
      :href                   => "https://api.spotify.com/v1/albums/2O9mD7oKwBnhQZQUAJM6GM"
      :id                     => "2O9mD7oKwBnhQZQUAJM6GM"
      :images                 => JSON3.Object[{…
      :label                  => "OOO Universal Music"
      :name                   => "200 По встречной"
      :popularity             => 47
      :release_date           => "2002-01-01"
      :release_date_precision => "day"
      :total_tracks           => 12
      :tracks                 => {…
      :type                   => "album"
      :uri                    => "spotify:album:2O9mD7oKwBnhQZQUAJM6GM"
    ```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album)
"""
function album_get_single(album_id; market = "")
    aid = SpAlbumId(album_id)
    u = "albums/$aid"
    a = urlstring(; market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    album_get_tracks(album_id; limit = 20, offset = 0, market = "")

**Summary**: Get Spotify catalog information about an album's tracks. Optional parameters
            can be used to limit the number of tracks returned.

# Arguments
- `album_id` : The Spotify ID for the album

# Optional keywords
- `limit`         : The maximum number of tracks to return. Default is set to 20.
- `offset` : The index of the first track to return. Default is 0.
- `market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> album_get_tracks("2O9mD7oKwBnhQZQUAJM6GM")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/albums/2O9mD7oKwBnhQZQUAJM6GM/tracks?offset=0&limit=20"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => nothing
  :offset   => 0
  :previous => nothing
  :total    => 12
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks)
"""
function album_get_tracks(album_id; limit = 20, offset = 0, market = "")
    u = "albums/$album_id/tracks"
    a = urlstring(; limit, offset, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    album_get_multiple(album_ids; market = "")

**Summary**: Get Spotify catalog information for multiple albums identified by their Spotify IDs.

# Arguments
- `album_ids` : A comma-separated list of the Spotify IDs for the albums. Maximum: 20 IDs.

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> album_get_multiple(["2O9mD7oKwBnhQZQUAJM6GM", "3eLvDNfWAMpytqIp073FEc"])[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :albums => JSON3.Object[{…
```

More formally,
```julia-repl
julia> album_get_multiple(SpAlbumId.(["5XgEM5g3xWEwL4Zr6UjoLo", "2rpT0freJsmUmmPluVWqg5"]))[1]
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-albums)
"""
function album_get_multiple(album_ids; market = "")
    u = "albums"
    a = urlstring(;ids = album_ids, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    album_get_saved(;limit = 20, market = "", offset = 0)

**Summary**: Get a list of the albums saved in the current Spotify user's 'Your Music' library.

# Optional keywords
- `limit`         : Maximum number of items to return, default is set to 20
- `market`        : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                    only episodes that are available in that market will be returned.
                    Default is set to "US".
- `offset`        : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> album_get_saved()[1]

JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/albums?offset=0&limit=20"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/me/albums?offset=20&limit=20"
  :offset   => 0
  :previous => nothing
  :total    => 33
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-albums)
"""
function album_get_saved(;limit = 20, market = "", offset = 0)
    u = "me/albums"
    a = urlstring(;limit, market, offset)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read")
end


"""
    album_get_contains(album_ids)

**Summary**: Check if one or more albums is already saved in the current Spotify user's 'Your Music' library.

# Arguments
- `ids` : A comma-separated list of the Spotify album IDs

# Example
```julia-repl
julia> album_get_contains(["2O9mD7oKwBnhQZQUAJM6GM", "3eLvDNfWAMpytqIp073FEc"])[1]
2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
 0
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-albums)
"""
function album_get_contains(album_ids)
    u = "me/albums/contains"
    ids = SpAlbumId.(album_ids)
    a = urlstring(;ids)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read")
end


"""
    album_remove_from_library(album_ids)
**Summary**: Remove one or more albums for the current user's 'Your Music' library.

# Arguments
- `album_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.

# Example

```julia-repl
julia> album_remove_from_library(["2O9mD7oKwBnhQZQUAJM6GM", "3eLvDNfWAMpytqIp073FEc"])[1]
{}
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-albums-user/)
"""
function album_remove_from_library(album_ids)
    u = "me/albums"
    ids = SpAlbumId.(album_ids)
    a = urlstring(;ids)
    url = build_query_string(u, a)
    spotify_request(url, "DELETE"; scope= "user-library-modify")
end


"""
    album_save_library(album_ids)

** Summary**: Save one or more albums to the current user's 'Your Music' library.

# Arguments

`album_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50.

# Example

```julia-repl
julia> album_save_library(["2O9mD7oKwBnhQZQUAJM6GM", "3eLvDNfWAMpytqIp073FEc"])[1]
{}
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-albums-user/)
"""
function album_save_library(album_ids)
    u = "me/albums"
    ids = SpAlbumId.(album_ids)
    a = urlstring(;ids)
    url = build_query_string(u, a)
    spotify_request(url, "PUT"; scope= "user-library-modify")
end