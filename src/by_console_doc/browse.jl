## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-category

"""
    category_get_single(category_id; country="", locale::String="en")

**Summary**: Get a single category used to tag items in Spotify (on, for example, the Spotify player’s “Browse” tab).

# Arguments
- `category_id` : The Spotify category ID for the category.

# Optional keywords
- `country::String` : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                      the list of returned items to be relevant to a particular country.
                      Default is set to "US".
- `locale::String` : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
Provide this parameter if you want the results returned in a particular language (where available).
Default is set to "en_US".

# Example
```julia-repl
julia> category_get_single("party")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 4 entries:
  :href  => "https://api.spotify.com/v1/browse/categories/party"
  :icons => JSON3.Object[{…
  :id    => "party"
  :name  => "Party"
```
"""
function category_get_single(category_id; country::String="", locale::String="")
    url_ext = "browse/categories/$category_id"
    if country != ""
        url_ext *= "?country=$country"
    end
    if country !="" && locale != ""
      url_ext *= "&"
    elseif locale != ""
      url_ext *= "?"
    end
    if locale != ""
        @assert occursin("_", locale)
        lang, langcountry = split(locale, '_')
        @assert lang == lowercase(lang)
        @assert langcountry == uppercase(langcountry)
        url_ext *= "locale=$locale"
    end
    return spotify_request(url_ext)
end


# Same as playlist_get_category in playlists.jl
category_get_playlist(category_id; country="US", limit = 20, offset = 0) = playlist_get_category(category_id;  country, limit, offset)


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-categories

"""
    category_get_multiple(;country="", locale::String="en", limit=20, offset::Int64=0)

**Summary**: Get a list of categories used to tag items in Spotify (on, for example, the Spotify player’s “Browse” tab).

# Optional keywords
- `country::String` : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                      the list of returned items to be relevant to a particular country.
                      Default is set to "US".
- `locale::String` : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
Provide this parameter if you want the results returned in a particular language (where available).
Default is set to "en_US".
- `limit`         : Maximum number of items to return, default is set to 20
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> category_get_multiple()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :categories => {…
```
"""
function category_get_multiple(;country="", locale::String="en", limit=20, offset::Int64=0)
    return spotify_request("browse/categories?country=$country&locale=$locale&limit=$limit&offset=$offset")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-new-releases

"""
    category_get_new_releases(;country="", locale::String="en", limit=20, offset::Int64=0)

**Summary**: Get a list of new album releases featured in Spotify (shown, for example, on a Spotify player’s “Browse” tab).

# Optional keywords
- `country::String` : An ISO 3166-1 alpha-2 country code. Provide this parameter if you want
                      the list of returned items to be relevant to a particular country.
                      Default is set to "US".
- `locale::String` : The desired language, consisting of a lowercase ISO 639-1 language code and an uppercase
ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)".
Provide this parameter if you want the results returned in a particular language (where available).
Default is set to "en_US".
- `limit`         : Maximum number of items to return, default is set to 20
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> category_get_new_releases()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :albums => {…
```
"""
function category_get_new_releases(;country="", locale::String="en", limit=20, offset::Int64=0)
    return spotify_request("browse/new-releases?country=$country&locale=$locale&limit=$limit&offset=$offset")
end


# Same as playlist_get_featured in playlists.jl
function category_get_featured_playlist(;country="US",locale="en", limit=50, offset=0, timestamp=string(now())[1:19])
    return playlist_get_featured(;country, locale, limit, offset, timestamp)
end




