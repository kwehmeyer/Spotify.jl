
using JSON, HTTP

# authorize from files, add access token to header
include("authorization/authorization.jl"); include("credentials.jl")
auth = AuthorizeSpotify(CLIENT_ID,CLIENT_SECRET)
header = ["Authorization" => "Bearer $(auth.access_token)"]

##

function spotify_request(method::String="GET",url_ext::String)
    println("Request URL:       https://api.spotify.com/v1/$url_ext")
    HTTP.payload(HTTP.request($method,"https://api.spotify.com/v1/$url_ext", header), String) |> JSON.parse
end

function get_album(id::String; query::String="?market=US")
    return spotify_request("albums/$id$query")
end

###################
# Search Function #
###################
# https://developer.spotify.com/documentation/web-api/reference/search/search/#writing-a-query---guidelines
function 