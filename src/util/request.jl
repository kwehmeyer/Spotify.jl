
# Use the access token to access the Spotify Web API
# https://developer.spotify.com/documentation/general/guides/authorization-guide/#client-credentials-flow

"Access the Spotify Web API"
function spotify_request(url_ext::String, method::String= "GET"; scope = "client-credentials")
    # Not so cool, but this is how we get rid of spaces in vectors of strings:
    url_ext = replace(url_ext, ' ' => "")
    url = "https://api.spotify.com/v1/$url_ext"
    headers = header_maker(;scope)
    isnothing(headers) && return()
    resp = HTTP.Messages.Response()
    try
        resp = HTTP.request(method, url, headers)
    catch e
        knowntype = e isa HTTP.ExceptionRequest.StatusError && e.status == 401
        if knowntype
            response_body = e.response.body |> String
            @error response_body
            return nothing
        else
            @warn "HTTP.request call: method = $method\n headers = $headers \n $url_ext"
            @error e
            return nothing
        end
    end
    response_body = resp.body |> String
    response_body |> JSON3.read
end

#=
"""
Access the Spotify web api through the 'Implicit grant flow'.
Implicit grant flow is for clients that are implemented entirely 
using JavaScript and running in the resource owner’s browser.
Julia: No prob.!
..but we do launch a browser for login..
"""
function other_request()
    error("ouch - not used")
    url = OAUTH_AUTHORIZE_URL
    headers = header_maker("Bearer")
    resp = HTTP.Messages.Response()
    method = "GET"
    try
        resp = HTTP.request(method, url, headers)
    catch e
        request = "HTTP.request call: method = $method\n  url = $url\n  headers = $headers \n"
        @error request
        @error e
        return nothing
    end
    response_body = resp.body |> String
    response_body |> JSON3.read
end
=#