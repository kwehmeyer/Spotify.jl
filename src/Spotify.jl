module Spotify

using HTTP,
        Base64,
        JSON,
        Parameters,
        Dates


# Authorization
include("authorization/authorization.jl")
export AuthorizeSpotify
include("authorization/credentials.jl")
spotcred = AuthorizeSpotify(CLIENT_ID, CLIENT_SECRET)

# Util
include("util/utilities.jl")
include("util/request.jl")
export spotify_request

# Browse
include("browse.jl")

# Tracks
include("tracks.jl")

# Shows
include("shows.jl")

# Albums 
include("albums.jl")

# Artist
include("artist.jl")

# Episodes
include("episodes.jl")

# Library
include("library.jl")

# Personalization
include("personalization.jl")

end # module
