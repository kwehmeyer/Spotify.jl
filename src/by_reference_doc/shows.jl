# Shows are the same as podcasts (series) on Spotify


"""
    show_get(show_id; market = get_user_country())

**Summary**: Get a Spotify catalog information for a single show identified by it's unique Spotify ID.

# Arguments
- `show_id` : The Spotify ID for the show

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. If a country code is specified, only shows
             and episodes that are available in that market will be returned. If market is
             not provided, the content is considered unavailable for the client.
             Default value is taken from user's .ini file.

# Example
```julia-repl
julia> show_get_single("2MAi0BvDc6GTFvKFPXnkCL")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 18 entries:
  :available_markets    => ["AD", "AE", "AG", "AL", "AM", "AR", "AT", "AU", "BA", "BB"  …  "TV", "TW", "US", "UY", "VC", …
  :copyrights           => Union{}[]
  :description          => "Conversations about science, technology, history, philosophy and the nature of intelligence, …
  :episodes             => {…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-show)
"""
function show_get_single(show_id; market = get_user_country())
    sid = SpShowId(show_id)
    u = "shows/$sid"
    a = urlstring(;market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    show_get_multiple(ids; market = get_user_country())

**Summary**: Get Spotify catalog information for several shows based on their Spotify IDs.

# Arguments
- `show_ids` : A comma-separated list of the Spotify IDs for the shows. Maximum: 50 IDs.

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. If a country code is specified, only shows
             and episodes that are available in that market will be returned. If market is
             not provided, the content is considered unavailable for the client.
             Default value is taken from user's .ini file.

# Example
```julia-repl
julia> julia> show_ids = SpShowId.(["5AvwZVawapvyhJUIx71pdJ", "6ups0LMt1G8n81XLlkbsPo"])
2-element Vector{SpShowId}:
 spotify:show:5AvwZVawapvyhJUIx71pdJ
 spotify:show:6ups0LMt1G8n81XLlkbsPo

julia> shs = show_get_multiple(show_ids)[1];

julia> [s.name for s in shs.shows]
3-element Vector{String}:
 "The Giant Beastcast"
 "The Filmcast (AKA The Slashfilmcast)"
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-shows)
"""
function show_get_multiple(show_ids; market = get_user_country())
    ids = SpShowId.(show_ids)
    u = "shows"
    a = urlstring(; ids, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    show_get_episodes(show_id; market = get_user_country(), limit = 20, offset = 0)

**Summary**: Get Spotify catalog information about a show’s episodes. Optional parameters
             can be used to limit the number of episodes returned.

# Arguments
- `show_id` : The Spotify ID for the show

# Optional keywords
- `market`         : An ISO 3166-1 alpha-2 country code. If market is not provided, the content
                     is considered unavailable for the client.
                     Default value is taken from user's .ini file.
- `limit`          : Maximum number of items to return, default is set to 20. (0 < limit <= 50)
- `offset`         : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> ses = show_get_episodes("2MAi0BvDc6GTFvKFPXnkCL")[1];

julia> [s.name for s in ses.episodes.items]
50-element Vector{String}:
 "#359 – Andrew Strominger: Black" ⋯ 17 bytes ⋯ "ravity, and Theoretical Physics"
 "#358 – Aella: Sex Work, OnlyFans, Porn, Escorting, Dating, and Human Sexuality"
 "#357 – Paul Conti: Narcissism, " ⋯ 18 bytes ⋯ "and the Nature of Good and Evil"
 "#356 – Tim Dodd: SpaceX, Starship, Rocket Engines, and Future of Space Travel"
 "#355 – David Kipping: Alien Civilizations and Habitable Worlds"
 "#354 – Jeremi Suri: American Civil War"
 ⋮
 "#315 – Magnus Carlsen: Greatest Chess Player of All Time"
 "#314 – Liv Boeree: Poker, Game " ⋯ 18 bytes ⋯ "tion, Aliens & Existential Risk"
 "#313 – Jordan Peterson: Life, Death, Power, Fame, and Meaning"
 "#312 – Duncan Trussell: Comedy, Sentient Robots, Suffering, Love & Burning Man"
 "#311 – Magatte Wade: Africa, Capitalism, Communism, and the Future of Humanity"
 "#310 – Andrew Bustamante: CIA Spy"
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-shows-episodes)
"""
function show_get_episodes(show_id; market = get_user_country(), limit = 20, offset = 0)
    sid = SpShowId(show_id)
    u = "shows/$sid"
    a = urlstring(;market, limit, offset)
    url = build_query_string(u, a)
    spotify_request(url)
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-shows)
"""
function show_get_saved(;limit = 20, offset = 0)
    u = "me/shows"
    a = urlstring(; limit, offset)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read")
end


"""
    show_get_contains(show_ids)

**Summary**: Check if one or more shows is already saved in the current Spotify user's library.

# Arguments
- `ids` : A comma-separated list of the Spotify IDs for the shows. Maximum: 50 IDs.

# Example
```
julia> show_ids = SpShowId.(["5AvwZVawapvyhJUIx71pdJ", "6ups0LMt1G8n81XLlkbsPo"])
2-element Vector{SpShowId}:
 spotify:show:5AvwZVawapvyhJUIx71pdJ
 spotify:show:6ups0LMt1G8n81XLlkbsPo

julia> show_get_contains(show_ids)[1]
2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1
 1
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-shows)
"""
function show_get_contains(show_ids)
    ids = SpShowId.(show_ids)
    u = "me/shows/contains"
    a = urlstring(; ids)
    url = build_query_string(u, a)
    spotify_request(url; scope = "user-library-read", additional_scope="user-library-modify")
end


"""
    show_remove_from_library(show_ids)

**Summary**: Remove one or more shows for the current user's library.

`show_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.

# Example
```julia-repl
julia> show_remove_from_library(["5AvwZVawapvyhJUIx71pdJ", "6ups0LMt1G8n81XLlkbsPo"])[1]
{}
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-shows-user/)
"""
function show_remove_from_library(show_ids)
    method = "DELETE"
    ids = SpShowId.(show_ids)
    u = "me/shows"
    a = urlstring(; ids)
    url = build_query_string(u, a)
    spotify_request(url, method, scope="user-library-modify")
end


"""
    show_save_library(show_ids)
# Save Shows for Current User
** Summary**: Save one or more shows to the current user's library.

`show_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50.

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-shows-user/)
"""
function show_save_library(show_ids)
    method = "PUT"
    ids = SpShowId.(show_ids)
    u = "me/shows"
    a = urlstring(; ids)
    url = build_query_string(u, a)
    spotify_request(url, method, scope="user-library-modify")
end