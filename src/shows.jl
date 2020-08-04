# shows.jl
## https://developer.spotify.com/documentation/web-api/reference/shows/

## https://developer.spotify.com/documentation/web-api/reference/shows/get-a-show/
@doc """
# Get a Show
**Summary**: Get a Spotify catalog information for a single show identified by it's unique Spotify ID.\n

`show_id` _Required_: The Spotify ID for the show. Up to 50 shows can be passed seperated with a comma. No whitespace.\n
`market` _Optional_: An ISO 3166-1 alpha-2 country code.
If a country code is specified, only shows and episodes that are available in that market will be returned.

[Reference](https://developer.spotify.com/documentation/web-api/reference/shows/get-a-show/)
"""
function show_get(show_id, market="US")
    return spotify_request("shows/$show_id") 
end



## https://developer.spotify.com/documentation/web-api/reference/shows/get-shows-episodes/

function show_get_episodes(show_id, market="US", limit=50, offset=0)
    return spotify_request("shows/$show_id/episodes?market=$market&limit=$limit&offset=$offset")
end