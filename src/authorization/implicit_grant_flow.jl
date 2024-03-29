"""
    receive_grant_as_request(req::HTTP.Request)

This handler is called by `launch_async_single_grant_receiving_server`,
when the server receives a request from the browser.
We return a response for user feedback, but the main
effect is that we update the credentials stored in memory.
"""
function receive_grant_as_request(req::HTTP.Request)
    target = String(HTTP.Messages.getfield(req, :target))
    uri = HTTP.URI(target)
    query = uri.query
    urisstring = HTTP.unescapeuri(query)
    params = HTTP.queryparams(urisstring) # create URI out of target String
    wewant = ["access_token", "token_type", "state", "expires_in"]
    ipa = filter(pa-> in(pa[1], wewant), params)
    if length(ipa) > 3
        if get(ipa, "state", "") == "987"
            if get(ipa, "token_type", "") == "Bearer"
                c = spotcred()::SpotifyCredentials
                # We have an Implicit Grant!
                c.ig_access_token = get(ipa, "access_token", "")
                c.token_type = get(ipa, "token_type", "")
                expi_in = parse(Int, get(ipa, "expires_in", 0))
                c.expires_at = string(Dates.now() + Dates.Second(expi_in))
                SPOTCRED[] = c
                # Console feedback also in 'wait_for_ig_access'
                msg = """Token type 'bearer' received from browser through request uri and stored. This is an implicit grant.
                             You can inspect with `Spotify.spotcred()`, `Spotify.expiring_in()`,
                             or e.g. `Spotify.credentials_contain_scope("user-read-private")`
                             This message is sent back to the browser, which you can close."""
                @info msg
                # This response is sent to our local browser, not to Spotify!
                return HTTP.Response(202, msg)
            else
                msg = "Unexpected token_type"
                @error msg
                return HTTP.Response(400, msg)
            end
        else
            sta = get(ipa, "state", "")
            msg = "Unexpected state: $sta"
            @error msg
            return HTTP.Response(400, msg)
        end
    elseif length(ipa) > 0
        le = length(ipa)
        msg = "We expected a request with 3 out of these 4 fields: 'access_token', 'token_type', 'state', 'expires_in' \n
            ...but received $le fields: $ipa"
        @error msg
        return HTTP.Response(400, msg)
    else
        if target == "/favicon.ico"
            HTTP.Response(404)
        else
            fpath = joinpath(@__DIR__, "standardize_uri.html")
            HTTP.Response( 200, body = read(fpath ) )
        end
    end
end

"has_ig_access_token()"
function has_ig_access_token()
    c = spotcred()::SpotifyCredentials
    t = c.ig_access_token
    t != ""
end

"wait_for_ig_access(; timeout_in_seconds = 30)"
function wait_for_ig_access(; timeout_in_seconds = 30)
    stopwait = now() + Dates.Second(timeout_in_seconds)
    while !has_ig_access_token() && now() < stopwait
        sleep(0.1)
    end
    if now() >= stopwait
        @info "Timeout access_grant_server, did not receive grant in $timeout_in_seconds seconds." maxlog = 1
    else
        @info "Received implicit grant token expires in $(expiring_in())" maxlog = 1
    end
end


"""
    launch_async_single_grant_receiving_server()

Called by `apply_and_wait_for_implicit_grant`.

The server runs asyncronously. It stays open a certain time, waiting for a request containing
a new grant. The grant is negotiated between Spotify and the user of the browser we launch.

The request is received from the browser, which got it from Spotify. This server hands
the request over to `receive_grant_as_request`.

Server closes after some time, or when the grant has been received and stored.
"""
function launch_async_single_grant_receiving_server()
    stored = spotcred().redirect   # "http://127.0.0.1:8080/api", String
    stripped = strip(stored, '/')  # "http://127.0.0.1:8080/api", SubString{String}
    u = parse(HTTP.URI, stripped)       # URI("http://127.0.0.1:8080/api")
    if length(stored) == 0 
        @error "Something went wrong, missing redirect URI in spotcred()."
        return (@async(nothing), @async(nothing))
    end
    host() = parse(HTTP.IPAddr, u.host)
    port() = parse(Int, u.port)
    path() = u.path
    println("\tListening for user authorization through browser on $(host()):$(port()) and path $(path())")
    server = Ref(Sockets.listen(host(), port()))
    # Invalidate the current credentials storage,
    # in case we are waiting for an extension of scope or a refresh.
    # Otherwise, the waiting loop below would exit at once.
    spotcred().ig_access_token = ""
    close_server_when_ready_task = @async begin
        wait_for_ig_access()
        close(server[])
        "Server is closed, and this string can be inspected in this task's result field."
    end
    # We're not interested in HTTPs conversation with REPL, so use the NullLogger.
    listen_task = with_logger(NullLogger()) do 
        @async HTTP.serve(receive_grant_as_request,
                                  host(), port();
                                  server = server[],
                                  stream =false)
    end
    listen_task, close_server_when_ready_task
end


"""
    launch_a_browser_that_asks_for_implicit_grant(;scopes::Vector{String} = DEFAULT_IMPLICIT_GRANT)

Called by `apply_and_wait_for_implicit_grant`.

Launch an available browser with an uri that contains the scope we are looking for. Exit at once.

"""
function launch_a_browser_that_asks_for_implicit_grant(;scopes::Vector{String} = DEFAULT_IMPLICIT_GRANT)
    uri = OAUTH_AUTHORIZE_URL * "?" *
            "client_id=" * spotcred().client_id *
            "&redirect_uri=" * replace(spotcred().redirect, "/" => "%2F") *
            "&scope=" * join(scopes, "%20") *
            "&show_dialog=true" *
            "&response_type=token" *
            "&state=987"
    println("\tLaunching a browser at: $(string(uri)[1:49])...\n")

    # Try opening a browser based on OS type
    if Sys.isapple()
        run(`open $uri`)
    end
    if Sys.iswindows()
        comm = ``
        for shortbrowsername in BROWSERS
            comm = launch_command_windows(shortbrowsername; url = uri)
            if comm != ``
                break
            end
        end
        run(comm, wait = false)
    end
    if Sys.islinux()
        run(`xdg-open $uri`)
    end
end


"""
    apply_and_wait_for_implicit_grant(;scopes::Vector{String} = DEFAULT_IMPLICIT_GRANT)

1) Start the negotiations for an extended scope!
2) Wait for it!
The result shows up in console, and in the stored credentials.
"""
function apply_and_wait_for_implicit_grant(;scopes::Vector{String} = DEFAULT_IMPLICIT_GRANT)
    if ! authorize()
        @info "Can't apply for implicit grant - `authorize()` client credentials!"
        t1 = Base.schedule(Base.Task((()->nothing)))
        t2 = Base.schedule(Base.Task((()->nothing)))
        return t1, t2
    end
    # These tasks are stored for potential inspection during debugging.
    listen_task, close_server_when_ready_task = launch_async_single_grant_receiving_server()
    yield() # Let those async tasks get going
    if !istaskdone(listen_task) && !istaskdone(close_server_when_ready_task)
        # We want to include any previously granted scopes.
        existing =  spotcred().ig_scopes
        scopelist = union(existing, scopes)
        launch_a_browser_that_asks_for_implicit_grant(;scopes = scopelist)
        yield() # Let that external process get going
        wait_for_ig_access()
        if credentials_still_valid() && has_ig_access_token()
            # 'receive_grant_as_request' did receive a coded token,
            # but that function did not know what the grant was for,
            # namely 'scopes'. But we know, and now store that info.
            spotcred().ig_scopes = scopelist
            @info "Successfully retrieved grant of these scopes: $scopelist"
        else
            @warn "We were not granted these scopes: $scopelist"
        end
    end
    listen_task, close_server_when_ready_task
end

function browser_path_windows(shortname)
    # windows accepts English paths anywhere.
    # Forward slash is acceptable too.
    trypath = ""
    homdr = ENV["HOMEDRIVE"]
    path64 = homdr * "/Program Files/"
    path32 = homdr * "/Program Files (x86)/"
    if shortname == "chrome"
        trypath = path64 * "Google/Chrome/Application/chrome.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Google/Chrome/Application/chrome.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "firefox"
        trypath = path64 * "Mozilla Firefox/firefox.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Mozilla Firefox/firefox.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "safari"
        trypath = path64 * "Safari/Safari.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Safari/Safari.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "iexplore"
        trypath = path64 * "Internet Explorer/iexplore.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Internet Explorer/iexplore.exe"
        isfile(trypath) && return trypath
    end
    return ""
end


"Constructs windows launch command"
function launch_command_windows(shortbrowsername; url = DEFAULT_REDIRECT_URI)
    pt = browser_path_windows(shortbrowsername)
    if pt == ""
        return ``
    else
        if shortbrowsername !== "chrome"
            return Cmd( [ pt, url])
        else
            # Dark mode is also a windows setting, so specifying this here is dubious practice.
            # However, Spotify is dark by default, so flashing a white screen in user's eyes can
            # be quite irritating.
            # Note, this command-line swith only has an effect if this is the first Chrome tab we're opening.
            return Cmd( [ pt, url, "--force-dark-mode"])
        end
    end
end