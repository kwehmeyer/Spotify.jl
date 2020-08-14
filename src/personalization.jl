# personalization.jl
## https://developer.spotify.com/documentation/web-api/reference/personalization/

## https://developer.spotify.com/documentation/web-api/reference/personalization/get-users-top-artists-and-tracks/

function top_tracks(offset=0, limit=20, time_range="medium")
    return spotify_requests("me/top/tracks?offset=$offset&limit=$limit&time_range=($time_range)_term")

end


##

function top_artists(offset=0, limit=20, time_range="medium")
    return spotify_requests("me/top/artists?offset=$offset&limit=$limit&time_range=($time_range)_term")

end