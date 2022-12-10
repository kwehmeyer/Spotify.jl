# Also see related functions in users.jl and follow.jl

"""
    top_tracks(;offset=0, limit=20, time_range="medium_term")

**Summary**: Get the current user's top tracks based on calculated affinity.

# Optional keywords
- `offset` _Optional_: The index of the first tracks to return. Default 0.\n
- `limit` _Optional_: The number of tracks to return. Default 20. \n
- `time_range` _Optional_: Over what time frame the affinities are computed.
                            Valid Options:
                            * `long_term` : Calculated from several years of data including all new data as it becomes available
                            * `medium_term` : Approx. last 6 months
                            * `short_term` : Approx. last 4 weeks
"""
function top_tracks(;offset=0, limit=20, time_range="medium_term")

    #url1 = "me/top/tracks?offset=$offset&limit=$limit"
    url1 = "me/top/tracks?offset=$offset&limit=$limit"
    url2 = "&time_range=$time_range"

    return spotify_request(url1 * url2; scope = "user-top-read")

end


"""
    top_artists(;offset=0, limit=20, time_range="medium_term")

**Summary**: Get the current user's top artists based on calculated affinity.

# Optional keywords
- `offset` _Optional_: The index of the first tracks to return. Default 0.\n
- `limit` _Optional_: The number of tracks to return. Default 20. \n
- `time_range` _Optional_: Over what time frame the affinities are computed.
                            Valid Options:
                            * `long_term` : Calculated from several years of data including all new data as it becomes available
                            * `medium_term` : Approx. last 6 months
                            * `short_term` : Approx. last 4 weeks
"""
function top_artists(;offset=0, limit=20, time_range="medium_term")

    url1 = "me/top/artists?offset=$offset&limit=$limit"
    url2 = "&time_range=$time_range"

    return spotify_request(url1 * url2; scope = "user-top-read")

end