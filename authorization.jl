## Libraries

using Revise
using HTTP
using JSON3
using Base64
using Parameters

include("credentials.jl")
import Base64.base64encode

##
@with_kw struct SpotifyCredentials
    client_id::String
    client_secret::String
    encoded_credentials::String = ""
    access_token::String = "" 
end

##
function base64encode(sc::SpotifyCredentials)
    encoded_creds = base64encode(sc.client_id * ":" * sc.client_secret)
    return SpotifyCredentials(client_id=sc.client_id, client_secret = sc.client_secret, encoded_credentials = encoded_creds)
end

##
function GetAuthorizationToken(sc::SpotifyCredentials)
    header = ["Authorization" => "Basic $(sc.encoded_credentials)","Content-Type" => "application/x-www-form-urlencoded"]
    body = "grant_type=client_credentials"
    response_json = HTTP.post(URL, header, body).body |> String |> JSON3.read
    return SpotifyCredentials(client_id=sc.client_secret,
    client_secret=sc.client_secret, encoded_credentials = sc.encoded_credentials, access_token  = response_json.access_token)
end

##
#=
Example of Authorization.

credentials = SpotifyCredentials(client_id = CLIENT_ID, client_secret = CLIENT_SECRET)
credentials = base64encode(credentials)
credentials = GetAuthorizationToken(credentials)
=#
