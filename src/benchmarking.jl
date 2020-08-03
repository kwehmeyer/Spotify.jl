using BenchmarkTools

include("request.jl")

#get_album("0sNOF9WDwhWunNAHPD3Baj")
@time spotify_request()


#response = get_album("0sNOF9WDwhWunNAHPD3Baj")

#response |> println

response["label"]


# test the get album function\
HTTP.request("https://api.spotify.com/v1/$url_ext", header)