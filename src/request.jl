# Use the access token to access the Spotify Web API
# https://developer.spotify.com/documentation/general/guides/authorization-guide/#client-credentials-flow

const RESP_DIC = include("lookup/response_codes_dic.jl")
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
    scope = "client-credentials", additional_scope = "", body = "",
    logstate = LOGSTATE)
    if method == "PUT" || method == "DELETE" || method == "POST"
        # Some requests include a body, some don't!
    else
        @assert body == "" "No need to define body for other than a 'POST' request!"
    end
    # Not so cool, but this is how we get rid of spaces in vectors of strings:
    url_ext = replace(url_ext, ' ' => "")
    url = "https://api.spotify.com/v1/$url_ext"
    authorizationfield = get_authorization_field(;scope, additional_scope)
    if authorizationfield == ("" => "")
        # Warnings enough were issued already.
        return JSON3.Object(), 0
    end
    resp = HTTP.Messages.Response()
    try
        if method == "GET"
            resp = HTTP.request(method, url, [authorizationfield])
        elseif method == "POST" || method == "PUT" || method == "DELETE"
            #@assert method !== "DELETE" "Delete requests are currently out of order"
            resp = HTTP.request(method, url, [authorizationfield], body)
        else
            throw("unexpected method")
        end
        # This request was OK, so this feedback is included for transparency and review.
        request_to_stdout(method, url, body, authorizationfield, logstate, true)
    catch e
        request_to_stdout(method, url, body, authorizationfield, logstate, false)
        if  e isa HTTP.ExceptionRequest.StatusError && e.status ∈ keys(RESP_DIC) #[400, 401, 403, 404, 429]
            response_body = e.response.body |> String
            code_meaning = get(RESP_DIC, Int(e.status), "")
            if response_body != ""
                response_object = JSON3.read(response_body)
                response_message = response_object.error.message
                msg = "$(e.status) (code meaning): $code_meaning \n\t\t(response message): $response_message"
            else
                msg = "$(e.status): $code_meaning"
            end
            @info msg
            if e.status == 400  # e.g. when a search query is empty
                return JSON3.Object(), 0
            elseif e.status == 403
                printstyled("  This code may be triggered by insufficient authorization scope(s).\n Consider: `apply_and_wait_for_implicit_grant()`", color = :red)
                printstyled("  scope(s) required for this API call: ", scope, " ", additional_scope, "\n", color = :red)
                printstyled("     scopes in current credentials: ", spotcred().ig_scopes, "\n", color = :red)
                logstate.authorization && printstyled("               authorization field: ", authorizationfield, "\n", color = :red)
                return JSON3.Object(), 0
            elseif e.status == 404 # Not found, e.g. when a track/playlist/album ID is incorrect
                return JSON3.Object(), 0
            elseif e.status == 405 
                return JSON3.Object(), 0
            elseif e.status == 429 # API rate limit temporarily exceeded.
                retry_in_seconds =  HTTP.header(e.response, "retry-after") 
                return JSON3.Object(), parse(Int, retry_in_seconds)
            else # 401 probably
                @warn "Error code $(e.status). You should probably try `authorize()` or \n\tor `apply_and_wait_for_implicit_grant()`"
                return JSON3.Object(), 0
            end
        else
            msg = "HTTP.request call (unexpected error): method = $method\n header with authorization field = $authorizationfield \n $url_ext"
            @warn msg
            if e isa HTTP.Exceptions.ConnectError
                @error string(e.url)
                @error string(e.error)
                return JSON3.Object(), 0
            else
                response_body = e.response.body |> String
                code_meaning = "?"
                msg = "$(e.status): $code_meaning"
                @error msg
                @error string(e)
                return JSON3.Object(), 0
            end
        end
    end
    response_body = resp.body |> String
    if method == "PUT"
        if ! (resp.status == 204 && ! logstate.empty_response)
            code_meaning = get(RESP_DIC, Int(resp.status), "")
            msg = "$(resp.status): $code_meaning"
            @info msg
        end
        return JSON3.Object(), 0
    else
        if resp.status == 204
            # This may occur if, for example, user is not associated with the requested country 
            # code, or if the state of a player is requested while no player app is active.
            if logstate.empty_response
                code_meaning = get(RESP_DIC, Int(resp.status), "")
                msg = "$(resp.status): $code_meaning"
                @info msg
            end
            return JSON3.Object(), 0
        else
            return JSON3.read(response_body), 0
        end
    end
end

"""
    request_to_stdout(method, url, body, authorizationfield, logstate, no_mistake)

Print a request after it is made.
"""
function request_to_stdout(method, url, body, authorizationfield, logstate, no_mistake)
    if no_mistake
        color = :light_black
    else
        color = :red
    end
    if logstate.request_string
        if body == ""
            printstyled("     ", method, " ", url, "\n"; color)
        else
            printstyled("     ", method, " ", url, "   \\", body, "\n"; color)
        end
    end
    # We want to be able to reuse console output for examples, so hiding confidential output is a choice:
    if logstate.authorization
        printstyled("               authorization field: ", authorizationfield, "\n"; color)
        printstyled("     scopes in current credentials: ", spotcred().ig_scopes, "\n"; color)
    end
end