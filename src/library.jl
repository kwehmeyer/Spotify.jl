# library.jl
## https://developer.spotify.com/documentation/web-api/reference/library/

## https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/

function library_get_saved_tracks(limit=20, offset=0, market="US")
    return spotify_request("me/tracks?market=$market&offset=$offset&limit=$limit")
end

## https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-shows/

function library_get_saved_shows(limit=20, offset=0)
    return spotify_request("me/shows?limit=$limit&offset=$offset")
end