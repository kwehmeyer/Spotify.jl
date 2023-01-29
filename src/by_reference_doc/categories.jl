"Same as playlist_get_featured in Playlists"
function category_get_featured_playlist(;country = "US", locale = "en", limit = 50, offset = 0, timestamp = string(now())[1:19])
    playlist_get_featured(;country, locale, limit, offset, timestamp)
end


"Same as playlist_get_category in Playlists"
function category_get_playlist(category_id; country = "", limit = 20, offset = 0)
    playlist_get_category(category_id;  country, limit, offset)
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-categories
"""
    category_get_multiple(;country = "", locale = "", limit = 20, offset = 0)

**Summary**: Get a list of categories used to tag items in Spotify (on, for example, the Spotify player’s “Browse” tab).

# Optional keywords
- `country`       : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    If omitted, the returned items will be relevant to all countries.
- `locale`          : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
Provide this parameter if you want the results returned in a particular language (where available).
Default is set to "en_US".
- `limit`         : Maximum number of items to return, default is set to 20
- `offset`        : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> category_get_multiple()[1].categories.items .|> i-> i.name
20-element Vector{String}:
 "Top Lists"
 "EQUAL"
 "Pop"
 ⋮
 "Rock"
 "Metal"
 "Sleep"```
"""
function category_get_multiple(;country = "", locale = "", limit = 20, offset = 0)
    assert_locale(locale)
    u = "browse/categories"                                                                                                                                                                  
    a = urlstring(;country, locale, limit, offset)                                                                                                                                                       
    url = build_query_string(u, a) 
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-new-releases
"""
    category_get_new_releases(;country = "", locale = "", limit = 20, offset = 0)

**Summary**: Get a list of new album releases featured in Spotify (shown, for example, on a Spotify player’s “Browse” tab).

# Optional keywords
- `country`       : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    If omitted, the returned items will be relevant to all countries.
- `locale`        : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
                    ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
                    Provide this parameter if you want the results returned in a particular language (where available).
                    Default is set to "en_US".
- `limit`         : Maximum number of items to return, default is set to 20
- `offset`        : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> category_get_new_releases()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :albums => {…
```
"""
function category_get_new_releases(;country = "", locale = "", limit = 20, offset = 0)
    assert_locale(locale)
    u = "browse/new-releases"
    a = urlstring(;country, locale, limit, offset)
    url = build_query_string(u, a)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-category
"""
    category_get_single(category_id; country = "", locale = "")

**Summary**: Get a single category used to tag items in Spotify (on, for example, the Spotify player’s “Browse” tab).

# Arguments
- `category_id` : The Spotify category ID for the category.

# Optional keywords
- `country`       : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                    the list of returned items to be relevant to a particular country.
                    If omitted, the returned items will be relevant to all countries.
- `locale`          : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
Provide this parameter if you want the results returned in a particular language (where available).
Default is set to "en_US".

# Example
```julia-repl
julia> category_get_single("party")[1].name
"Party"

julia> category_get_single("party", locale = "es_MX")[1].name
"Fiesta"
```
"""
function category_get_single(category_id; country = "", locale = "")
    assert_locale(locale)
    u = "browse/categories/$category_id"
    a = urlstring(;country, locale)
    url = build_query_string(u, a)
    spotify_request(url)
end
