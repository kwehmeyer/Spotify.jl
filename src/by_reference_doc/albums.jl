## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album

"""
    album_get_single(album_id; market="US")

**Summary**: Get Spotify catalog information for a single album.

# Arguments
- `album_id` : The Spotify ID for the album.

# Optional keywords                         
`market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> Spotify.album_get_single("5XgEM5g3xWEwL4Zr6UjoLo")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 18 entries:
  :album_type             => "album"
  :artists                => JSON3.Object[{…
  :copyrights             => JSON3.Object[{…
  :external_ids           => {…
  :external_urls          => {…
  :genres                 => Union{}[]
```
"""
function album_get_single(album_id; market="US")
    return spotify_request("albums/$album_id?market=$market") 
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks

"""
    album_get_tracks(album_id; limit=20, offset=0, market="US")

**Summary**: Get Spotify catalog information about an album's tracks. Optional parameters 
             can be used to limit the number of tracks returned.
             
# Arguments
`album_id` : The Spotify ID for the album

# Optional keywords
`limit` : The maximum number of tracks to return. Default is set to 20.
`offset` : The index of the first track to return. Default is 0.
`market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> Spotify.album_get_tracks("5XgEM5g3xWEwL4Zr6UjoLo")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/albums/5XgEM5g3xWEwL4Zr6UjoLo/tracks?offset=0&limit=20&market=US"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/albums/5XgEM5g3xWEwL4Zr6UjoLo/tracks?offset=20&limit=20&market=US"
```
"""
function album_get_tracks(album_id; limit=20, offset=0, market="US")
    return spotify_request("albums/$album_id/tracks?limit=$limit&offset=$offset&market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-albums

"""
    album_get_multiple(album_ids; market="US")

**Summary**: Get Spotify catalog information for multiple albums identified by their Spotify IDs.    

# Arguments
`album_ids` : A comma-separated list of the Spotify IDs for the albums. Maximum: 20 IDs.

# Optional keywords
`market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> Spotify.album_get_multiple("5XgEM5g3xWEwL4Zr6UjoLo, 2rpT0freJsmUmmPluVWqg5")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :albums => JSON3.Object[{…
```
"""
function album_get_multiple(album_ids; market="US")
    return spotify_request("albums?ids=$album_ids&market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-albums

"""
    album_get_saved(;limit::Int64=20, market::String="US", offset::Int64=0)

**Summary**: Get a list of the albums saved in the current Spotify user's 'Your Music' library.

# Optional keywords
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified, 
                     only episodes that are available in that market will be returned. 
                     Default is set to "US".
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> Spotify.album_get_saved()[1]
[ Info: We try the request without checking if current grant includes scope user-library-read.
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/albums?offset=0&limit=20&market=US"
  :items    => JSON3.Object[{…
  :limit    => 20
```
"""
function album_get_saved(;limit::Int64=20, market::String="US", offset::Int64=0)
    
    return spotify_request("me/albums?limit=$limit&market=$market&offset=$offset"; 
    scope = "user-library-read")

end