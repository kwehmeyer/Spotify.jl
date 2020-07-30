## Packages and Includes
using Revise
using HTTP
using DataFrames
using JSONTables
using JSON

##
base_url = "https://api.spotify.com/v1"
cat_url = "/browse/categories"

##
function list_categories()
    header = ["Authorization" => "Bearer $(credentials.access_token)"]
    data = HTTP.get((base_url * cat_url), header)
    data = HTTP.payload(data, String)
    data = JSON.parse(data)
    return data
end
##