## Libraries

using Revise
using HTTP
using JSON
using Base64
using Parameters

include("credentials.jl")
import Base64.base64encode

##
# I can't believe I lost all my work
ENCODED_CREDS = base64encode(CLIENT_ID*":"*CLIENT_SECRET)

##
URL = "https://accounts.spotify.com/api/token"
HEADER = ["Authorization" => "Basic $ENCODED_CREDS", "Content-Type" => "application/x-www-form-urlencoded"]
body = "grant_type=client_credentials"
HTTP.post(URL, HEADER, body)

##
@with_kw struct SpotifyCredentials
    client_id::String
    client_secret::String
    encoded_credentials::String = ""
    access_token::String = "" 
end
##
SC = SpotifyCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)

##
function base64encode(sc::SpotifyCredentials)
    encoded_creds = base64encode(sc.client_id * ":" * sc.client_secret)
    return SpotifyCredentials(client_id=sc.client_id, client_secret = sc.client_secret, encoded_credentials = encoded_creds)
end

##
SC = base64encode(SC)

##
function GetAuthorizationToken(sc::SpotifyCredentials)
    header = ["Authorization" => "Basic $(sc.encoded_credentials)","Content-Type" => "application/x-www-form-urlencoded"]
    body = "grant_type=client_credentials"
    return HTTP.post(URL, header, body)
end

##
GetAuthorizationToken(SC)