# https://developer.spotify.com/documentation/web-api/reference/browse/get-list-new-releases/
##

using Revise, HTTP, JSON

##

base_url = "https://api.spotify.com/v1"
release_url = "/browse/new-releases"

##
function get_new_releases()
    header = ["Authorization" => "Bearer $(credentials.access_token)"]
    data = HTTP.get((base_url * release_url), header)
    data = HTTP.payload(data, String)
    data = JSON.parse(data)
    return data
end

##
get_new_releases()