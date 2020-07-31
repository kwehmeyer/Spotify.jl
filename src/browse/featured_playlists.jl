# This code is outside the scope of the individual function. base_url will be contained in the abstract class. my current knowledge is that the header will only ever conatin the authorization credentials. 

using Revise, JSON, HTTP
base_url = "https://api.spotify.com/v1"
header = ["Authorization" => "Bearer $(credentials.access_token)"]

function get_featured_playlists()
    var_url = "/browse/featured-playlists/"
    return HTTP.payload(HTTP.get(base_url * var_url, header), String) |> JSON.parse
end