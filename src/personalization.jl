# personalization.jl
## https://developer.spotify.com/documentation/web-api/reference/personalization/

## https://developer.spotify.com/documentation/web-api/reference/personalization/get-users-top-artists-and-tracks/
@doc """
# Get a User's Top Tracks
**Summary**: Get the current user's top trakcs based on calculated affinity

`offset` _Optional_: The index of the first tracks to return. Default 0.\n 
`limit` _Optional_: The number of tracks to return. Default 20. \n
`time_range` _Optional_: Over what time frame the affinities are computer.
Valid Options:
* `long` : Calculated from several years of data including all new data as it becomes available
* `medium` : Approx. the last 6 months of data.
* `short` : Approx. the last 4 weeks

[Reference](https://developer.spotify.com/documentation/web-api/reference/personalization/get-users-top-artists-and-tracks/)
""" ->
function top_tracks(offset=0, limit=20, time_range="medium")
    return spotify_request("me/top/tracks?offset=$offset&limit=$limit&time_range=($time_range)_term")

end


@doc """
# Get a User's Top Artists
**Summary**: Get the current user's top artists based on calculated affinity

`offset` _Optional_: The index of the first artist to return. Default 0.\n 
`limit` _Optional_: The number of artists to return. Default 20. \n
`time_range` _Optional_: Over what time frame the affinities are computer.
Valid Options:
* `long` : Calculated from several years of data including all new data as it becomes available
* `medium` : Approx. the last 6 months of data.
* `short` : Approx. the last 4 weeks

[Reference](https://developer.spotify.com/documentation/web-api/reference/personalization/get-users-top-artists-and-tracks/)
""" ->
function top_artists(offset=0, limit=20, time_range="medium")
    return spotify_request("me/top/artists?offset=$offset&limit=$limit&time_range=($time_range)_term")
end