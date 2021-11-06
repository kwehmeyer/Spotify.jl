function request_handler(req::HTTP.Request)
    target = String(HTTP.Messages.getfield(req, :target))
    uri = HTTP.URI(target)
    query = uri.query
    urisstring = unescapeuri(query)
    params = HTTP.queryparams(urisstring) # create URI out of target String
    wewant = ["access_token", "token_type", "state", "expires_in"]
    ipa = filter(pa-> in(pa[1], wewant), params)
    if length(ipa) > 3
        if get(ipa, "state", "") == "987"
            if get(ipa, "token_type", "") == "Bearer"
                c = spotcred()::SpotifyCredentials
                c.ig_access_token = get(ipa, "access_token", "")
                c.token_type = get(ipa, "token_type", "")
                expi_in = parse(Int, get(ipa, "expires_in", 0))
                c.expires_at = string(Dates.now() + Dates.Second(expi_in))
                SPOTCRED[] = c
                # Feedback in 'wait_for_ig_access'
            else
                @error "Unexpected token_type"
            end
        else
            @error "Unexpected state"
        end
        HTTP.Response(202, repr(ipa))
    elseif length(ipa) > 0
        @error "Unexpected query string: $query"
        HTTP.Response(202, repr(ipa))
    else
        if target == "/favicon.ico"
            HTTP.Response(404)
        else
            fpath = joinpath(@__DIR__, "standardize_uri.html")
            HTTP.Response( 200, body = read(fpath ) )
        end
    end
end

function has_ig_access_token()
    c = spotcred()::SpotifyCredentials
    t = c.ig_access_token
    t != ""
end
function wait_for_ig_access(; stopwait::DateTime = now() + Dates.Second(20))
    while !has_ig_access_token() && now() < stopwait  
        sleep(0.1)
    end
    now() >= stopwait  ? println("\n\tTimeout server") : println("\n\tImplicit grant token expires at $(SPOTCRED[].expires_at) - closing server")
end

function start_a_listening_server()
    stored = spotcred().redirect
    stripped = strip(stored, '/')
    u = parse(URI, stripped)
    host() = parse(IPAddr, u.host)
    port() = parse(Int, u.port)
    path() = u.path
    server = Sockets.listen(host(), port())
    close_server_when_ready_task = @async begin
        wait_for_ig_access()
        close(server)
    end
    println("\tListening for authorization on $(host()):$(port()) and path $(path())")
    listen_task = @async HTTP.serve(request_handler, host(), port(); server, stream =false)
    listen_task, close_server_when_ready_task
end


function launch_a_browser_that_asks_for_implicit_grant()
    scopes = join(DEFAULT_IMPLICIT_GRANT, "%20")
    uri = OAUTH_AUTHORIZE_URL * "?" *
            "client_id=" * spotcred().client_id *
            "&redirect_uri=" * replace(spotcred().redirect, "/" => "%2F") *
            "&scope=" * scopes *
            "&show_dialog=true" *
            "&response_type=token" *
            "&state=987"
    println("\tLaunching a browser at: $uri")
    success = false
    #=
    browsercmd = get_working_browser_cmd()
    if browsercmd != ``
        @info "Browser command from .ini-file: $browsercmd"
    end
    =#
    browser = ""
    while !success && COUNTBROWSER.value < length(BROWSERS)
        #if browsercmd != ``
        printstyled("\tTrying to launch browser candidate: $(BROWSERS[COUNTBROWSER.value + 1])\n"; color = :green)
        success, browser = open_a_browser(url= uri)

        # Added delay so that user can authorize via browser window while running unit tests
        @info "Waiting for 15 seconds"
        sleep(15)
        
        #else
        #    printstyled("\tBrowser command from .ini-file: $browsercmd\n"; color = :green)
        #    @async run(browsercmd)
        #    break
        #end
    end
    # Reset browser picker
    COUNTBROWSER.value = 0
    #=
    if browsercmd == "" && COUNTBROWSER.value <= length(BROWSERS)
        browsercmd = launch_command(browser; url = uri)
    end
    if browsercmd != ``
        printstyled("\tStoring browser command:$(browsercmd)\n", color = :green)
        set_working_browser_cmd(browsercmd)
    end
    =#
end

"""
If the user gives us access, that will be in the future.
Is it worth waiting for? If so, call `wait_for_ig_access()`
"""
function get_implicit_grant()
    listen_task, close_server_when_ready_task = start_a_listening_server()
    launch_a_browser_that_asks_for_implicit_grant()
    listen_task, close_server_when_ready_task
end
