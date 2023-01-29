const ALLSCOPES = include("../lookup/all_scopes_vector.jl")
function credentials_contain_scope(single_scope::String)
    @assert single_scope ∈ ALLSCOPES || single_scope == ""  "Not valid scope: $single_scope."
    single_scope ∈ spotcred().ig_scopes || single_scope == ""
end

"""
    get_authorization_field(;scope = "client-credentials", additional_scope = "")

For Spotify requests, provide authorization field.
If 'scope' is outside current grant, apply to user / Spotify for more.
"""
function get_authorization_field(;scope = "client-credentials", additional_scope = "")
    if !credentials_still_valid()
        if spotcred().client_id ==""
            @warn "Client credentials missing.\n Try `authorize()`!"
            return "" => ""
        else
            msg = "Credentials expired at $(spotcred().expires_at).\n
                You should probably try `authorize()`"
            @warn msg
            return "" => ""
        end
    end
    if scope == "client-credentials"
        if additional_scope == "" 
            sendtoken =  spotcred().access_token
        else
            throw("unexpected scope combination")
        end
    else
        if !has_ig_access_token() || !credentials_contain_scope(scope) || !credentials_contain_scope(additional_scope)
            if has_ig_access_token()
                @info "We will ask user to extend our implicit grant to also include $scope"
                scopes = spotcred().ig_scopes
            else
                @info "We will ask user for implicit grant including $scope"
                scopes = Vector{String}()
            end
            !credentials_contain_scope(scope) && push!(scopes, scope)
            !credentials_contain_scope(additional_scope) && push!(scopes, additional_scope)
            listen_task, close_server_when_ready_task = apply_and_wait_for_implicit_grant(;scopes)
            wait_for_ig_access()
        end
        sendtoken =  spotcred().ig_access_token
    end
    # Consider: User may have denied permission 
    #           User may not have noticed the browser popping up
    #           User may have been too slow
    #           Credentials may have expired (we warned about that)
    # In these cases, user will notice denied requests, which should be shown.
    return "Authorization" => "Bearer $sendtoken"
end

function time_to(timepoint::String)
    time_to(parse(DateTime, timepoint))
end
function time_to(timepoint::DateTime)
    n = now()
    tdiff = timepoint - n
    round(tdiff, Second)
end
function expiring_in()
    time_to(spotcred().expires_at)
end
credentials_still_valid() = expiring_in() > Second(0)

