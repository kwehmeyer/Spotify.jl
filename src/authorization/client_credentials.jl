"""
    authorize()
    -> Bool

Get and store client credentials. Any other credentials will be dropped.
"""
function authorize()
    # This deletes .ig_access_token and ig_scopes.
    # There may be a better way, so that we can keep the granted scopes.
    @info "Negotiating client credentials, which typically last 1 hour." maxlog=1
    SPOTCRED[] = get_spotify_credentials()
    if string(SPOTCRED[]) != string(SpotifyCredentials())
        if credentials_still_valid()
            msg = """Client credentials expire in $(expiring_in()).
                           You can inspect with `Spotify.spotcred()`, `Spotify.expiring_in()`,
                            or e.g. `Spotify.credentials_contain_scope("user-read-private")`
                 """
            @info msg
            return true
        else
            @info "Client credentials are expired. When ready, `authorize()` again."
            return false
        end
    else
        @info "When configured, `authorize()` again."
        return false
    end
end

function get_spotify_credentials()
    c = get_init_file_spotify_credentials()
    if string(c) == string(SpotifyCredentials())
        # The ini file didn't contain what was needed.
        return c
    end
    j = get_authorization_token(c)
    if isempty(j)
        # Warnings were issued, we assume here.
        return c
    end
    c.access_token = j.access_token
    c.token_type = j.token_type
    c.expires_at = string(Dates.now() + Dates.Second(j.expires_in))
    c
end



function get_authorization_token(sc_tokenless::SpotifyCredentials)
    refreshtoken = sc_tokenless.encoded_credentials
    headers = ["Authorization" => "Basic $refreshtoken",
              "Accept" => "*/*",
              "Content-Type" => "application/x-www-form-urlencoded"]
    body = "grant_type=client_credentials"
    resp = HTTP.Messages.Response()
    try
        resp = HTTP.post(AUTH_URL, headers, body)
    catch e
        if e isa HTTP.Exceptions.ConnectError
            @error "ConnectionError"
        else
            request = "HTTP.post call: AUTH_URL = $AUTH_URL\n  headers = $headers \n  body = $body"
            @error request
            @error e
        end
        return JSON3.Object()
    end
    response_body = resp.body |> String
    response_body |> JSON3.read
end

function get_init_file_spotify_credentials()
    id, secret, redirect = get_id_secret_redirect()
    if id == NOT_ACTUAL || secret == NOT_ACTUAL
        @warn "User needs to configure $(_get_ini_fnam())"
        SpotifyCredentials()
    else
        enc_cred = base64encode(id * ":" * secret)
        c = SpotifyCredentials(client_id = id, client_secret =secret, encoded_credentials = enc_cred)
        c.redirect = redirect
        c
    end
end



"Get id and secret as 32-byte string, no encryption"
function get_id_secret_redirect()
    container = read(Inifile(), _get_ini_fnam())
    id = get(container, "Spotify developer's credentials", "CLIENT_ID",  NOT_ACTUAL)
    secret = get(container, "Spotify developer's credentials", "CLIENT_SECRET",  NOT_ACTUAL)
    redirect = get(container, "Spotify developer's credentials", "REDIRECT_URI",  DEFAULT_REDIRECT_URI)
    id, secret, redirect
end

function get_user_name()
    container = read(Inifile(), _get_ini_fnam())
    get(container, "Spotify user id", "user_name",  "")
end

"Get an existing, readable ini file name, create it if necessary"
function _get_ini_fnam()
    fna = joinpath(homedir(), "spotify_credentials.ini")
    if !isfile(fna)
        open(fna, "w+") do io
            _prepare_init_file_with_instructions(io)
        end
        if Sys.iswindows()
            run(`cmd /c $fna`; wait = false)
        end
        println("Instructions in $fna")
    end
    fna
end

function _prepare_init_file_with_instructions(io)
    conta = Inifile()
    set(conta, "User procedure:", "1: How to get the CLIENT_ID", "Developer.spotify.com -> Dashboard -> log in -> Create an app -> Fill out name and purpose -> Copy to the field below.")
    set(conta, "User procedure:", "2: How to get CLIENT_SECRET", "When you have client id, press 'Show client secret' -> Copy to below. No need for quotation marks.")
    set(conta, "User procedure:", "3: How to give REDIRECT_URL", "Still in the app dashboard:
    'Edit settings' -> Redirect uris -> http://127.0.0.1:8080 -> Save changes")
    set(conta, "Spotify developer's credentials", "CLIENT_ID", NOT_ACTUAL)
    set(conta, "Spotify developer's credentials", "CLIENT_SECRET", NOT_ACTUAL)
    set(conta, "Spotify developer's credentials", "REDIRECT_URI", "http://127.0.0.1:8080")
    set(conta, "Spotify user id", "user_name", "Slartibartfast")
    write(io, conta)
end




