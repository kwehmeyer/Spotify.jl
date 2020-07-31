## Libraries

using Revise, HTTP, JSON3, Base64, Parameters

include("credentials.jl")
import Base64.base64encode
auth_url = "https://accounts.spotify.com/api/token"

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
    response_json = HTTP.post(auth_url, header, body).body |> String |> JSON3.read
    return SpotifyCredentials(client_id=sc.client_secret,
    client_secret=sc.client_secret, encoded_credentials = sc.encoded_credentials, access_token  = response_json.access_token)
end

##

function AuthorizeSpotify(client_id, client_secret)
    sc = SpotifyCredentials(client_id = client_id, client_secret = client_secret)
    sc = base64encode(sc)
    sc = GetAuthorizationToken(sc)
    return sc
end

#= 
How to authorize

`credentials = AuthorizeSpotify(CLIENT_ID, CLIENT_SECRET)`

Now credentials is a SpotifyCredentials object containing a .access_token string used for other HTTP calls

=#