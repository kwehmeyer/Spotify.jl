## Packages and Includes
using Revise
using HTTP
using DataFrames
using JSONTables
using JSON

##
struct SpotifyCategory 
    name 
    id 
    icons 
    href 
end
##
base_url = "https://api.spotify.com/v1"
cat_url = "/browse/categories"

##
header_cat = ["Authorization" => "Bearer $(credentials.access_token)"]

##
resp = HTTP.get((base_url * cat_url), header_cat)
##
htpayload = HTTP.payload(resp, String)
##
dict_resp = JSON.parse(htpayload) 
##
cats = []
for i in dict_resp["categories"]["items"]
    #println(DataFrame(i))
    push!(cats, DataFrame(i))
    println("~"^15)
end

##
cats_d = DataFrame()
for i in cats 
    append!(cats_d, i)
end
##
println(cats_d)