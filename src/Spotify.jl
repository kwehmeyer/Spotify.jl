"""
Module exports functions based on [documentation structure](https://developer.spotify.com/documentation/web-api/reference/) 
and the overlapping [console structure](https://developer.spotify.com/console/).

    using Spotify
    # See all functions :
    varinfo(Spotify; recursive = true)
    Or use tab_completion after typing

    Spotify.+tab
    Tracks.+tab

"""
module Spotify

using HTTP, Dates, IniFile, HTTP, JSON3, Sockets
using Logging: with_logger, NullLogger
import Dates
import Base64
using Base64: base64encode
using REPL.TerminalMenus
# This enables methods like `write(t <: SpType`
using JSON3: write 
using StructTypes
import StructTypes: StructType, lower #, lowertype
#
import Base: show, show_vector, isempty 
export authorize, apply_and_wait_for_implicit_grant, get_user_name
export select_calls, parse_copied_link, LOGSTATE

export SpId, SpCategoryId, SpPlaylistId, SpAlbumId, SpTrackId
export SpArtistId, SpShowId, SpEpisodeId
export JSON3
"For the client credentials flow"
const AUTH_URL = "https://accounts.spotify.com/api/token"
"For the 'Implicit grant flow'"
const OAUTH_AUTHORIZE_URL = "https://accounts.spotify.com/authorize"
const DEFAULT_REDIRECT_URI = "http://127.0.0.1:8080/api"
const NOT_ACTUAL = "Paste_32_bytes_in_inifile"
"A list of potentially available browsers, to be tried in succession if present"
const BROWSERS = ["chrome", "firefox", "edge", "safari", "phantomjs"]

Base.@kwdef mutable struct Logstate
    authorization::Bool = false
    request_string::Bool = false
    empty_response::Bool = false
end


"""
LOGSTATE mutable state
 -  .authorization::Bool
 -  .request_string::Bool
 -  .empty_response::Bool

Mutable flags for logging to REPL. Nice when 
making inline docs or new interfaces. 
This global can also be locally overruled with
keyword argument to `spotify_request`.
"""
const LOGSTATE = Logstate()

"Stored credentials"
Base.@kwdef mutable struct SpotifyCredentials 
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
Default requested permissions are 'client-credentials'.

These permissions are not requested until the current scope is
insufficient, or the user calls 'apply_and_wait_for_implicit_grant(;scopes)'
"""
const DEFAULT_IMPLICIT_GRANT = ["user-read-private",
                               "user-modify-playback-state",
                               "user-read-playback-state",
                               "playlist-modify-private",
                               "playlist-read-private"]

const DEFAULT_VALUES = Dict{Symbol, Any}()

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
include("util/lenient_conversion_to_string.jl")
include("util/parse_copied_link.jl")

# The below are structured by 'Docs' / 'Web api':
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


# The below is structured by the 'Console' tab (beside 'Docs')
# https://developer.spotify.com/console/

# Library
include("by_console_doc/library.jl")


# Export structure
include("export_structure.jl")

# Populate dictionary for select_calls() menu
let
    dic = include(joinpath(@__DIR__, "lookup/paramname_default_dic.jl"))
    merge!(DEFAULT_VALUES, dic)
end

function __init__()
    apply_and_wait_for_implicit_grant()
end

end # module
