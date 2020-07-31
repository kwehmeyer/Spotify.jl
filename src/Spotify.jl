module Spotify

using HTTP,
        Base64,
        JSON,
        Parameters


# Authorization
include("authorization/authorization.jl")
export AuthorizeSpotify

# Browse
include("browse/browse_category.jl")
include("browse/catetgory_playlist.jl")
include("browse/feautred_playlists.jl")
include("browse/list_categories.jl")
include("browse/list_new_releases.jl")
include("browse/recommendations.jl")


end # module
