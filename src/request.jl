
using JSON, HTTP

# authorize from files, add access token to header
include("authorization/authorization.jl"); include("credentials.jl")
auth = AuthorizeSpotify(CLIENT_ID,CLIENT_SECRET)
header = ["Authorization" => "Bearer $(authorization.access_token)"]

##

response = HTTP.payload(HTTP.get("https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj?market=US",header),String) |> 
JSON.parse

#response |> println

response["label"]

##
function spotify_request(url_ext::String="")
    println("Request URL:       https://api.spotify.com/v1/$url_ext")
    HTTP.payload(HTTP.get("https://api.spotify.com/v1/$url_ext", header), String) |> JSON.parse
end

function get_album(id::String; query::String="?market=US")
    return spotify_request("albums/$id$query")
end


response = get_album("0sNOF9WDwhWunNAHPD3Baj")

println(response["genres"])