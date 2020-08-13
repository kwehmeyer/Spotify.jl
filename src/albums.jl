# albums.jl
## https://developer.spotify.com/documentation/web-api/reference/albums/


## https://developer.spotify.com/documentation/web-api/reference/albums/get-album/
@doc """
# Get an Album(s)
**Summary**: Get Spotify catalog information for an album(s)

`album_id` _Required_: The Spotify ID for the album. Up to 20 albums can be passed by
comma separating the ID's\n 
`market` _Optional_: An ISO 3166-1 alpha-2 country code. Default "US"\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/albums/get-album/)
""" ->
function album_get(album_id, market="US")
    return spotify_request("albums/$album_id?market=$market") 
end



## https://developer.spotify.com/documentation/web-api/reference/albums/get-albums-tracks/
@doc """
# Get an Album's Tracks 
**Summary**: Get Spotify catalog information about an album's tracks. Optional parameters can be used to limit the number of tracks returned 

`album_id` _Required_: The Spotify ID for the album. Up to 20 albums can be passed by
`limit` _Optional_: The maximum number of tracks to return. Default 20\n 
`offset` _Optional_: The index of the first track to return. Default 0\n
`market` _Optional_: An ISO 3166-1 alpha-2 country code. Default "US"\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/albums/get-albums-tracks/)
""" ->
function album_get_tracks(album_id, limit=20, offset=0, market="US")
    return spotify_request("albums/$album_id/tracks?limit=$limit&offset=$offset&market=$market")
end