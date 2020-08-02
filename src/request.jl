
using JSON, HTTP

# authorize from files, add access token to header
include("authorization/authorization.jl"); include("credentials.jl")
auth = AuthorizeSpotify(CLIENT_ID,CLIENT_SECRET)
header = "Authorization" => "Bearer $(credentials.access_token)"

typeof(header)
##

HTTP.get("https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj?market=US",)

##
function spotify_request(url_ext::String="")
    print("https://api.spotify.com/v1/$url_ext")
    HTTP.get("https://api.spotify.com/v1/$url_ext",header)
    HTTP.payload(HTTP.get("https://api.spotify.com/v1/$url_ext", header), String) |> JSON.parse
end

function get_album(id::String; query::String="?market=US")
    spotify_request("albums/$id$query")
    #return spotify_request("albums/$id$query")
end

get_album("0sNOF9WDwhWunNAHPD3Baj")
##