

function spotify_request(url_ext::String, method::String="GET")
    #println("Request URL:       https://api.spotify.com/v1/$url_ext")
    #HTTP.payload(HTTP.request($method,"https://api.spotify.com/v1/$url_ext", header), String) |> JSON.parse
    return HTTP.request(method,"https://api.spotify.com/v1/$url_ext", header_maker())

end

##
spotify_request("browse/categories")