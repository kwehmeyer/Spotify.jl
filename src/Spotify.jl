"""
Module exports functions based on [documentation structure](https://developer.spotify.com/documentation/web-api/reference/)

    using Spotify
    # See all functions :
    varinfo(Spotify; recursive=true)
    Or use tab_complation after typing

    Spotify.+tab
    Tracks.+tab

"""
module Spotify
using HTTP, Parameters, Dates, IniFile, HTTP, StructTypes, JSON3, URIs, Sockets
using HTTP: handle
import Dates
import Base64
using Base64: base64encode
import Base: show, show_vector, typeinfo_implicit
export authorize, strip_embed_code
"For the client credentials flow"
const AUTH_URL = "https://accounts.spotify.com/api/token"
"For the 'Implicit grant flow"
const OAUTH_AUTHORIZE_URL = "https://accounts.spotify.com/authorize"
const DEFAULT_REDIRECT_URI = "http://127.0.0.1:8080/api"
const NOT_ACTUAL = "Paste_32_bytes_in_inifile"
"A list of potentially available browsers, to be tried in succession if present"
const BROWSERS = ["firefox", "edge", "chrome", "safari", "phantomjs"]

@with_kw mutable struct SpotifyCredentials
    client_id::String = ""
    client_secret::String = ""
    encoded_credentials::String = ""
    access_token::String = ""
    token_type::String = ""
    expires_at::String = string(Dates.DateTime(0))
    redirect::String = ""
    ig_access_token::String = ""
end

const SPOTCRED  = Ref{SpotifyCredentials}(SpotifyCredentials())

spotcred() = SPOTCRED[]

# Helper types - colorful aliases for 'String'.
include("types.jl")

# Authorization
include("authorization/client_credentials.jl")
include("authorization/open_a_browser.jl")
include("authorization/implicit_grant_flow.jl")

# Util
include("util/utilities.jl")
include("util/request.jl")

# Browse
include("by_reference_doc/browse.jl")

# Tracks
include("by_reference_doc/tracks.jl")

# Shows
include("by_reference_doc/shows.jl")

# Albums 
include("by_reference_doc/albums.jl")

# Artist
include("by_reference_doc/artist.jl")

# Episodes
include("by_reference_doc/episodes.jl")

# Library
include("by_reference_doc/library.jl")

# Personalization
include("by_reference_doc/personalization.jl")

# Follow
include("by_reference_doc/follow.jl")

# Export structure
include("export_structure.jl")


function __init__()
    authorize()
end
end # module
