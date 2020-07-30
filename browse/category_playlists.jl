# https://developer.spotify.com/documentation/web-api/reference/browse/get-categorys-playlists/
##
using Revise, JSON, HTTP

##
base_url = "https://api.spotify.com/v1"
cat_url = "/browse/categories/"

##
function get_category_playlists(category_id)
    header = ["Authorization" => "Bearer $(credentials.access_token)"]
    url = base_url * cat_url * category_id * "/playlists"
    data = HTTP.get(url, header)
    data = HTTP.payload(data, String)
    data = JSON.parse(data)
    
    return data 
end

##