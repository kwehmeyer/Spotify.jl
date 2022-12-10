# Use the access token to access the Spotify Web API
# https://developer.spotify.com/documentation/general/guides/authorization-guide/#client-credentials-flow

const RESP_DIC = include("lookup_containers/response_codes_dic.jl")
"""
    spotify_request(url_ext::String, method::String= "GET"; 
                    scope = "client-credentials", additional_scope = "")
     -> (r::JSON3.Object, retry_in_seconds::Int)

Access the Spotify Web API. This is called by every function 
in `/by_console_doc/` and `/by_reference_doc/`.
Error results return an empty Object. 
Errors are written to 'stderr', expect for 'API rate limit exceeded', as 
the output would typically occur in the middle of recursive calls.
"""
function spotify_request(url_ext::String, method::String= "GET"; 
    scope = "client-credentials", additional_scope = "", body = "")
    if method == "POST"
        @assert body != ""  
    else
        @assert body == "" "No need to define body for other than a 'POST' request!"
    end
    # Not so cool, but this is how we get rid of spaces in vectors of strings:
    url_ext = replace(url_ext, ' ' => "")
    url = "https://api.spotify.com/v1/$url_ext"
    authorizationfield = get_authorization_field(;scope, additional_scope)
    resp = HTTP.Messages.Response()
    try
        if method == "GET"
            resp = HTTP.request(method, url, [authorizationfield])
        elseif method == "POST"
            resp = HTTP.request(method, url, [authorizationfield], body)
        else
            throw("unexpected method")
        end
        printstyled("     ", method, " ", url, "\n", color=:light_black) # This was OK, so cluttering up the console perhaps.
        printstyled("               authorization field: ", authorizationfield, "\n", color=:light_black)
        printstyled("     scopes in current credentials: ", spotcred().ig_scopes, "\n", color=:light_black)
    catch e
        printstyled("     ", method, " ", url, "\n", color=:red) 
        if  e isa HTTP.ExceptionRequest.StatusError && e.status ∈ keys(RESP_DIC) #[400, 401, 403, 404, 429]
            response_body = e.response.body |> String
            code_meaning = get(RESP_DIC, Int(e.status), "")
            if response_body != ""
                response_object = JSON3.read(response_body)
                response_message = response_object.error.message
                msg = "$(e.status) (code meaning): $code_meaning \n\t\t(response message): $response_message"
            else
                response_message = ""
                msg = "$(e.status): $code_meaning"
            end
            @warn msg
            if e.status == 400  # e.g. when a search query is empty
                return JSON3.Object(), 0
            elseif e.status == 403
                printstyled("  This code may be triggered by insufficient authorization scope(s).\n Consider: `Spotify.apply_and_wait_for_implicit_grant()`", color=:red)
                printstyled("  scope(s) required for this API call: ", scope, " ", additional_scope, "\n", color=:red)
                printstyled("     scopes in current credentials: ", spotcred().ig_scopes, "\n", color=:red)
                printstyled("               authorization field: ", authorizationfield, "\n", color=:red)
                return JSON3.Object(), 0
            elseif e.status == 404 # Not found, e.g. when a track/playlist/album ID is incorrect
                return JSON3.Object(), 0
            elseif e.status == 429 # API rate limit temporarily exceeded.
                retry_in_seconds =  HTTP.header(e.response, "retry-after") 
                return JSON3.Object(), parse(Int, retry_in_seconds)
            else # 401 probably
                @info "Error code $e.status_ You should try to re-authenticate the user: \n\tSpotify.refresh_spotify_credentials()\n\tor\n\tSpotify.apply_and_wait_for_implicit_grant()  (this should retain previously granted scopes)"
                return JSON3.Object(), 0
            end
        else
            @warn "HTTP.request call (unexpected error): method = $method\n header with authorization field = $authorizationfield \n $url_ext"
            @error e
            @error response_body
            return JSON3.Object(), 0
        end
    end
    response_body = resp.body |> String
    response_body |> JSON3.read , 0
end
