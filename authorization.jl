## Libraries

using Revise
using HTTP
using JSON
using Base64
include("credentials.jl")

##
# I can't believe I lost all my work
ENCODED_CREDS = base64encode(CLIENT_ID*":"*CLIENT_SECRET)

##
URL = "https://accounts.spotify.com/api/token"
HEADER = ["Authorization" => "Basic $ENCODED_CREDS", "Content-Type" => "application/x-www-form-urlencoded"]
body = "grant_type=client_credentials"
HTTP.post(URL, HEADER, body)

##