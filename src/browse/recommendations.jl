# https://developer.spotify.com/documentation/web-api/reference/browse/get-recommendations/
##

base_url = "https://api.spotify.com/v1"
recommendation_url = "/recommendations"
    
##

function get_recommendations()
    header = ["Authorization" => "Bearer $(credentials.access_token)"]
    println(base_url * recommendation_url)
    data = HTTP.get((base_url * recommendation_url), header)
    data = HTTP.payload(data, String)
    data = JSON.parse(data)
    return data
end

##
get_recommendations()