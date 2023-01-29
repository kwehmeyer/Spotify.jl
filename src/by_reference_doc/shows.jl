# Shows are the same as podcasts (series) on Spotify

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-show

"""
    show_get(show_id; market = "")

**Summary**: Get a Spotify catalog information for a single show identified by it's unique Spotify ID.

# Arguments
- `show_id` : The Spotify ID for the show

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. If a country code is specified, only shows
             and episodes that are available in that market will be returned.

# Example
```julia-repl
julia> show_get_single("2MAi0BvDc6GTFvKFPXnkCL")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 18 entries:
  :available_markets    => ["AD", "AE", "AG", "AL", "AM", "AR", "AT", "AU", "BA", "BB"  …  "TV", "TW", "US", "UY", "VC", …
  :copyrights           => Union{}[]
  :description          => "Conversations about science, technology, history, philosophy and the nature of intelligence, …
  :episodes             => {…
```
"""
function show_get_single(show_id; market = "")
    u = "shows/$show_id"
    a = urlstring(;market)
    url = build_query_string(u, a)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-shows

"""
    show_get_multiple(ids; market = "")

**Summary**: Get Spotify catalog information for several shows based on their Spotify IDs.

# Arguments
- `ids` : A comma-separated list of the Spotify IDs for the shows. Maximum: 50 IDs.

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. If a country code is specified, only shows
             and episodes that are available in that market will be returned.

# Example
```julia-repl
julia> show_get_multiple("2MAi0BvDc6GTFvKFPXnkCL, 4rOoJ6Egrf8K2IrywzwOMk")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :shows => JSON3.Object[{…
```
"""
function show_get_multiple(ids; market = "")
    u = "shows"
    a = urlstring(; ids = ids, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-shows-episodes
"""
    show_get_episodes(show_id; market = "", limit = 20, offset = 0)

**Summary**: Get Spotify catalog information about a show’s episodes. Optional parameters
             can be used to limit the number of episodes returned.

# Arguments
- `show_id` : The Spotify ID for the show

# Optional keywords
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".
- `limit`          : Maximum number of items to return, default is set to 20. (0 < limit <= 50)
- `offset`         : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> show_get_episodes("2MAi0BvDc6GTFvKFPXnkCL")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/shows/2MAi0BvDc6GTFvKFPXnkCL/episodes?offset=0&limit=20&market=US"
  :items    => JSON3.Object[{…
  :limit    => 20
```
"""
function show_get_episodes(show_id; market = "", limit = 20, offset = 0)
    u = "shows/$show_id"
    a = urlstring(;market, limit, offset)
    url = build_query_string(u, a)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-shows

"""
    show_get_saved(;limit = 20, offset = 0)

**Summary**: Get a list of shows saved in the current Spotify user's library. Optional parameters can
             be used to limit the number of shows returned.

# Optional keywords
- `limit`          : Maximum number of items to return, default is set to 20. (0 < limit <= 50)
- `offset`         : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> show_get_saved()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/shows?offset=0&limit=20"
  :items    => Union{}[]
  :limit    => 20
```
"""
function show_get_saved(;limit = 20, offset = 0)
    u = "me/shows"
    a = urlstring(; limit, offset)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-shows
"""
    show_get_contains(ids)

**Summary**: Check if one or more shows is already saved in the current Spotify user's library.

# Arguments
- `ids` : A comma-separated list of the Spotify IDs for the shows. Maximum: 50 IDs.

# Note
- Scope was unsufficient, also when accessed through the web console:
┌ Info: 403 (code meaning): Forbidden - The server understood the request, but is refusing to fulfill it.
└               (response message): Insufficient client scope
"""
function show_get_contains(show_ids)
    return spotify_request("me/shows/contains?ids=$show_ids"; scope = "user-library-read", additional_scope="user-library-modify")
end

## https://developer.spotify.com/documentation/web-api/reference/library/remove-shows-user/
"""
# Remove Shows for Current User
**Summary**: Remove one or more shows for the current user's library.

`show_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-shows-user/)
"""
function show_remove_from_library(show_ids)
    return spotify_request("me/shows?ids=$show_ids", method = "DELETE", scope="user-library-modify")
end


## https://developer.spotify.com/documentation/web-api/reference/library/save-shows-user/
@doc """
# Save Shows for Current User
** Summary**: Save one or more shows to the current user's library.

`shows_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50.

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-shows-user/)
""" 
function show_save_library(show_ids)
    return spotify_request("me/shows?ids=$show_ids", method = "PUT", scope="user-library-modify")
end