

function parse_response(resp)
    return (
        HTTP.payload(resp, String) |> JSON.parse
    )
end

function header_maker(;scope="client-credentials")
    if scope == "client-credentials"
        if client_credentials_still_valid()
            return ["Authorization" => "Bearer $(spotcred().access_token)"]
        else
            @warn "Client credentials expired at $(spotcred().expires_at)"
        end
    elseif has_valid_bearer(scope)
        return ["Authorization" => "Bearer $(spotcred().ig_access_token)"]
    else
        @warn "Current scope not valid, exiting call: $scope"
    end
end

function has_valid_bearer(scope)
    if scope == "user access token"
        # No check if it has expired yet.
        spotcred().access_token != ""
    elseif has_ig_access_token()
        @info "We try the request without checking if current grant includes scope $scope." maxlog = 3
        true
    else
        @info "Starting asyncronous user authorization process. Try again later!"
        get_implicit_grant()
        #wait_for_ig_access()
        false
    end
end
"""
    strip_embed_code(sdvs<substring>)
    -> Spid(<substring>)

Get the interesting part for pasting:
    
Spotify app -> Right click -> Share -> Copy embed code to clipboard
"""
strip_embed_code(s) = SpId(match(r"\b[a-zA-Z0-9]{22}", s).match)