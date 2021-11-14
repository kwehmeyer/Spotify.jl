using Test
using Spotify

include("test_int_format_strings.jl")

include("generalize_calls.jl")

include("test_playlists.jl")

# Authorization via browser window is needed to access current user data, 
# delay for user action is therefore set to 10 seconds in implicit_grant_flow.jl
include("test_users.jl")

include("test_search.jl")

include("test_markets.jl")

include("test_genres.jl")

include("test_player.jl")

include("test_albums.jl")

include("test_artist.jl")

include("test_tracks.jl")

include("test_shows.jl")

include("test_browse.jl")