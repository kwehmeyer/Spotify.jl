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

function artist_get_albums(artist_id, include_groups="", country="US", limit=20, offset=0)
    if length(include_groups) > 0 
        return spotify_request("artists/$artist_id?include_groups=$include_groups&country=$country&limit=$limit&offset=$offset")
    else 
        return spotify_request("artists/$artist_id?country=$country&limit=$limit&offset=$offset")
    end
end