
## https://developer.spotify.com/documentation/web-api/reference/browse/get-category/

using Revise, JSON, HTTP

##
base_url = "https://api.spotify.com/v1"
cat_url = "/browse/categories/"

##
function get_category(category_id)
    header = ["Authorization" => "Bearer $(credentials.access_token)"]
    data = HTTP.get(base_url * cat_url * category_id, header)
    data = HTTP.payload(data, String)
    data = JSON.parse(data)
    return data
end

##