# artist.jl
## https://developer.spotify.com/documentation/web-api/reference/artists/

## https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/
@doc """
# Get an Artist
**Summary**: Get Spotify catalog information for a single artist identified by their unique Spotify ID. 

`artist_id` _Required_: The Spotify artist ID. Up to 50 artist ID's can be passed by comma delimiting the ID's 

[Reference](https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/)
""" ->
function artist_get(artist_id)
    return spotify_request("artists/$artist_id")
end


## https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-albums/
@doc """
# Get an Artists Albums 
**Summary**: Get Spotify catalog information about an artist's albums.

`artist_id` _Required_: The Spotify artist ID. Up to 50 artist ID's can be passed by comma delimiting the ID's\n
`include_groups` _Optional_: A comma-separated list of keywords that will be used to filter the response. If not supoplied, all album types will be returned.
Valid values:
* `album`
* `single`
* `compilation`
* `appears_on`

`country` _Optional_: An ISO 3166-1 alpha-2 country code string. Use this to limit the response to one particular geographical market. Default "US"\n 
`limit` _Optional_: The number of album objects to return. Default 20\n 
`offset` _Optional_: The index of the first album to return. Default 0\n

[Reference](https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-albums/)
""" ->
function artist_get_albums(artist_id, include_groups="None", country="US", limit=20, offset=0)
    if include_groups == "None"
        return spotify_request("artists/$artist_id?include_groups=$include_groups&country=$country&limit=$limit&offset=$offset")
    else 
        return spotify_request("artists/$artist_id?country=$country&limit=$limit&offset=$offset")
    end
end



## https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-top-tracks/

function artist_top_tracks(artist_id, country="US")
    return spotify_request("artists/$artist_id/top-tracks?country=$country")
end