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
# TODO:
#=
✓. Add more fields to Logstate
2. Replace code with 'urlstring', 'bodystring'. Partly done, e.g. in Player.
3. Change function arguments to optional. Especially country codes. Partly done, see Player.
✓. Refine DEFAULT_IMPLICIT_GRANT, check from fresh start using select_calls()
5. Possibly delete help text, refer to Spotify instead? OR update properly.
6. Revisit the type system. Delete it, or decide on if it needs to contain prefixes.
7. Use duck typing in all request wrapping functions. Because 'bodystring' and 'urlstring' 
   methods specialize on types, and names / defaults provide user the info actually needed.
8. Add spaces around '='. Not obvious choice, but easier to maintain: Same rule everywhere.
9. Move by_console_doc/follow to by_reference_doc/users
10. Drop default values: country = "US", locale = "en" 
11. Standardize Dates.now usage. Utilities?
12. In inline docs, use a short form of JSON display that doesn't include request strings.
    This makes source code hard to search in. 
13. Drop 'return' in in all request wrapping functions.
14. Drop unnecessary dependencies URIs and Parameters
=#
using HTTP, Dates, IniFile, HTTP, JSON3, Sockets
import Dates
import Base64
using Base64: base64encode
using REPL.TerminalMenus
import Base: show, show_vector, typeinfo_implicit
export authorize, apply_and_wait_for_implicit_grant, get_user_name
export select_calls, strip_embed_code, LOGSTATE
export SpUri, SpId, SpCategoryId, SpUserId, SpUrl, SpPlaylistId, SpAlbumId
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

mutable struct Logstate
    authorization::Bool
    request_string::Bool
    empty_response::Bool
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
const LOGSTATE = Logstate(true, true, false)

"Stored credentials"
mutable struct SpotifyCredentials
    client_id::String
    client_secret::String
    encoded_credentials::String
    access_token::String
    token_type::String
    expires_at::String
    redirect::String
    ig_access_token::String
    ig_scopes::Vector{String}
end
function SpotifyCredentials(; client_id = "", client_secret = "", encoded_credentials = "", access_token = "", token_type = "",
                            expires_at = string(Dates.DateTime(0)), redirect = "", ig_access_token = "", ig_scopes= String[]) 
    SpotifyCredentials(client_id, client_secret, encoded_credentials, access_token, token_type, expires_at, redirect, ig_access_token, ig_scopes)
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


# The below are structured by the 'Console' tab (beside 'Docs')
# https://developer.spotify.com/console/
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
    #success = authorize()
    #success && 
    apply_and_wait_for_implicit_grant()
end

end # module
