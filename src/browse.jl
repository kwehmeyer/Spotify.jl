# browse.jl
## https://developer.spotify.com/documentation/web-api/reference/browse/

## https://developer.spotify.com/documentation/web-api/reference/browse/get-category/
@doc """"
Get a single category used to tag items in Spotify (on, for example, the Spotify player’s “Browse” tab).\n

country: (Optional) A country: ISO 3166-1 alpha-2 country code. Provide this parameter to ensure that the category exists for a particular country.\n
locale: (Optional) The desired language, consisting of an ISO 639-1 language code and an ISO 3166-1 alpha-2 country code, joined by an underscore. For example: es_MX, meaning "Spanish (Mexico)". Provide this parameter if you want the category strings returned in a particular language. Note that, if locale is not supplied, or if the specified language is not available, the category strings returned will be in the Spotify default language (American English).\n
""" ->
function category_get(category_id, country="US", locale="en")
    return spotify_request("browse/categories/$category_id?country=$country&locale=$locale")

end



## https://developer.spotify.com/documentation/web-api/reference/browse/get-categorys-playlists/
@doc """
Get a list of Spotify playlists tagged with a particular category.\n 

country: (Optional) A country: an ISO 3166-1 alpha-2 country code.\n 
limit: (Optional) The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.\n 
offset: (Optional) The index of the first item to return. Default: 0 (the first object). Use with limit to get the next set of items.\n
""" ->
function category_get_playlist(category_id, country="US", limit = 20, offset = 0)
    return spotify_request("browse/categories/$category_id/playlists?country=$country&limit=$limit&offset=$offset")
end



## https://developer.spotify.com/documentation/web-api/reference/browse/get-list-categories/
@doc """
Get a list of categories used to tag items in Spotify (on, for example, the Spotify player’s “Browse” tab).\n 

country: (Optional) A country: an ISO 3166-1 alpha-2 country code.\n 
limit: (Optional) The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.\n 
offset: (Optional) The index of the first item to return. Default: 0 (the first object). Use with limit to get the next set of items.\n
""" ->
function category_get_several(country="US", locale="en", limit=20, offset=0)
    return spotify_request("browse/categories?country=$country&locale=$locale&limit=$limit&offset=$offset")
end



## https://developer.spotify.com/documentation/web-api/reference/browse/get-list-new-releases/
@doc """
Get a list of new album releases featured in Spotify (shown, for example, on a Spotify player’s “Browse” tab).\n 

country: (Optional) A country: an ISO 3166-1 alpha-2 country code. Provide this parameter if you want the list of returned items to be relevant to a particular country. If omitted, the returned items will be relevant to all countries.\n 
locale: (Optional) The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.\n 
offset: (Optional) Optional. The index of the first item to return. Default: 0 (the first object). Use with limit to get the next set of items.\n
""" ->
function category_get_new_releases(country="US", locale="en", limit=20, offset=0)
    return spotify_request("browse/new-releases?country=$country&locale=$locale&limit=$limit&offset=$offset")
end




## https://developer.spotify.com/documentation/web-api/reference/browse/get-list-featured-playlists/
@doc """
Get a list of Spotify featured playlists (shown, for example, on a Spotify player’s ‘Browse’ tab).\n 

country: (Optional) A country: an ISO 3166-1 alpha-2 country code. Provide this parameter if you want the list of returned items to be relevant to a particular country. If omitted, the returned items will be relevant to all countries.\n 
locale: (Optional) The maximum number of items to return. Default: 20. Minimum: 1. Maximum: 50.\n 
offset: (Optional) The index of the first item to return. Default: 0 (the first object). Use with limit to get the next set of items.\n
timestamp: (Optional) A timestamp in ISO 8601 format: yyyy-MM-ddTHH:mm:ss. 
Use this parameter to specify the user’s local time to get results tailored for that specific date and time in the day.
If not provided, the response defaults to the current UTC time. 
Example: “2014-10-23T09:00:00” for a user whose local time is 9AM.
If there were no featured playlists (or there is no data) at the specified time, the response will revert to the current UTC time.
""" -> 
function category_get_featured_playlist(country="US",locale="en", limit=50, offset=0, timestamp=string(now())[1:19])
    return spotify_request("browse/featured-playlists?country=$country&locale=$locale&limit=$limit&offset=$offset&timestamp=$timestamp")
end




## https://developer.spotify.com/documentation/web-api/reference/browse/get-recommendations/
@doc """
Get Recommendations Based on Seeds

seeds: (Required) A dictionary containing keys(seed_genres, seed_artists, seed_tracks) and values for each key being seeds delimeted by a comma up to 5 seeds for each category\n
Example\n 
Dict("seed_artists" => "s33dart1st,s33edart!st2", "seed_genres" => "g3nre1,genr32", "seed_tracks" => "trackid1,trackid2")\n

track_attributes: (Optional) a dictionary containing key values for different tunable track track_attributes\n 
See https://developer.spotify.com/documentation/web-api/reference/browse/get-recommendations/
""" ->
function recommendations_get(
    seeds,
    track_attributes,
    limit = 50,
    market = "US"

)
    track_attributes = recommendations_dict_parser(track_attributes)
    seeds = recommendations_dict_parser(seeds)
    return spotify_request("recommendations?$seeds&$track_attributes&limit=$limit&market=$market")
    


end


## Recommendations Helper Func
function recommendations_dict_parser(track_attributes::Dict)
    query = ""
    for (key,value) in track_attributes
        query = query * key * "=" * value * "&"
    end
    return query
end
