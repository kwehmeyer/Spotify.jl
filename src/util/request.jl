
# Use the access token to access the Spotify Web API
# https://developer.spotify.com/documentation/general/guides/authorization-guide/#client-credentials-flow

"""
    spotify_request(url_ext::String, method::String= "GET"; scope = "client-credentials")
     -> (r::JSON3.Object, retry_in_seconds::Int)

Access the Spotify Web API.
Error results return an empty Object. 
Errors are written to 'stderr', expect for 'API rate limit exceeded', as 
the output would typically occur in the middle of recursive calls.
"""
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
        if  e isa HTTP.ExceptionRequest.StatusError && e.status ∈ [400, 401, 403, 404, 429]
            response_body = e.response.body |> String
            if e.status == 429 # API rate limit temporarily exceeded.
                retry_in_seconds =  HTTP.header(e.response, "retry-after") 
                return JSON3.Object(), parse(Int, retry_in_seconds)

            elseif e.status == 404 # Not found, e.g. when a track/playlist/album ID is incorrect
                @info "404 Not Found - Check if input arguments are okay"
                return JSON3.Object(), 0

            elseif e.status == 403 
                @info "403 - Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...)"
                return JSON3.Object(), 0

            elseif e.status == 400 # e.g. when a search query is empty
                @info "Check if the search query is present"
                return JSON3.Object(), 0

            else
                @info "You should try to re-authenticate the user"
                @error response_body
                return JSON3.Object(), 0
            end
        else
            @warn "HTTP.request call: method = $method\n headers = $headers \n $url_ext"
            @error e
            @error response_body
            return JSON3.Object(), 0
        end
    end
    response_body = resp.body |> String
    response_body |> JSON3.read , 0
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