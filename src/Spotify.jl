"""
Module exports functions based on [documentation structure](https://developer.spotify.com/documentation/web-api/reference/) 
and the overlapping [console structure](https://developer.spotify.com/console/).

    using Spotify
    # See all functions :
    varinfo(Spotify; recursive=true)
    Or use tab_completion after typing

    Spotify.+tab
    Tracks.+tab

"""
module Spotify

using HTTP, Parameters, Dates, IniFile, HTTP, JSON3, URIs, Sockets
import Dates
import Base64
using Base64: base64encode
using Parameters: @with_kw
import Base: show, show_vector, typeinfo_implicit
export authorize, strip_embed_code
"For the client credentials flow"
const AUTH_URL = "https://accounts.spotify.com/api/token"
"For the 'Implicit grant flow'"
const OAUTH_AUTHORIZE_URL = "https://accounts.spotify.com/authorize"
const DEFAULT_REDIRECT_URI = "http://127.0.0.1:8080/api"
const NOT_ACTUAL = "Paste_32_bytes_in_inifile"
"A list of potentially available browsers, to be tried in succession if present"
const BROWSERS = ["chrome", "firefox", "edge", "safari", "phantomjs"]

"Stored credentials"
@with_kw mutable struct SpotifyCredentials
    client_id::String = ""
    client_secret::String = ""
    encoded_credentials::String = ""
    access_token::String = ""
    token_type::String = ""
    expires_at::String = string(Dates.DateTime(0))
    redirect::String = ""
    ig_access_token::String = ""
    ig_scopes::Vector{String} = String[]
end

"Current stored credentials, access by spotcred()"
const SPOTCRED  = Ref{SpotifyCredentials}(SpotifyCredentials())

"Access current stored credentials"
spotcred() = SPOTCRED[]

"""
These permissions are not requested until the current scope is
insufficient, or the user calls 'apply_and_wait_for_implicit_grant()'

Default requested permissions are 'client-credentials'.
"""
const DEFAULT_IMPLICIT_GRANT = ["user-read-private",
                                "user-read-email",
                                "user-follow-read",
                                "user-library-read",
                                "user-read-playback-state",
                                "user-read-recently-played",
                                "user-top-read"]

# Every API call is made through this
include("request.jl")

# Helper types - colorful aliases for 'String'.
include("types.jl")

# Authorization
include("authorization/client_credentials.jl")
include("authorization/implicit_grant_flow.jl")
include("authorization/access_local_credentials.jl")

# Util
include("util/utilities.jl")

#https://developer.spotify.com/documentation/web-api/reference/#/

# Albums 
include("by_reference_doc/albums.jl")

# Artists
include("by_reference_doc/artists.jl")

# Shows
include("by_reference_doc/shows.jl")

# Episodes
include("by_reference_doc/episodes.jl")

# Tracks
include("by_reference_doc/tracks.jl")

# Search
include("by_reference_doc/search.jl")

# Users
include("by_reference_doc/users.jl")

# Playlists
include("by_reference_doc/playlists.jl")

# Categories
include("by_reference_doc/categories.jl")

# Genres
include("by_reference_doc/genres.jl")

# Player
include("by_reference_doc/player.jl")

# Markets
include("by_reference_doc/markets.jl")


# The below are not structured by reference

# Browse
include("by_console_doc/browse.jl")

# Library
include("by_console_doc/library.jl")

# Personalization
include("by_console_doc/personalization.jl")

# Follow
include("by_console_doc/follow.jl")


# Export structure
include("export_structure.jl")

function __init__()
    authorize()
    apply_and_wait_for_implicit_grant()
end

end # module
