## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-analysis

"""
    tracks_get_audio_analysis(track_id)

**Summary**: Get a detailed audio analysis for a single track identified by it's unique Spotify ID.

# Arguments
- `track_id`: The Spotify ID for the track

# Example
```julia-repl
julia> Spotify.tracks_get_audio_analysis("6rqhFgbbKwnb9MLmUQDhG6")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :meta     => {…
  :track    => {…
  :bars     => JSON3.Object[{…
  :beats    => JSON3.Object[{…
```
"""
function tracks_get_audio_analysis(track_id)
    return spotify_request("audio-analysis/$track_id")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features

"""
    tracks_get_audio_features(track_id)

**Summary**: Get audio feature information for a single track identified by it's unique Spotify ID.

# Arguments
- `track_id`: The Spotify ID for the track

# Example
```julia-repl
julia> Spotify.tracks_get_audio_features("6rqhFgbbKwnb9MLmUQDhG6")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 18 entries:
  :danceability     => 0.592
  :energy           => 0.0196
  :key              => 1
  :loudness         => -33.35
  :mode             => 1
  :speechiness      => 0.0358
  :acousticness     => 0.362
  :instrumentalness => 0.854
```
"""
function tracks_get_audio_features(track_id)
    return spotify_request("audio-features/$track_id")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track

"""
    tracks_get(track_id; market="US")

**Summary**: Get a spotify catalog information for a single track identified by it's unique Spotify ID.

# Arguments
- `track_id` : The Spotify ID for the track.

# Optional keywords
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".

# Example
```julia-repl
julia> Spotify.tracks_get("6rqhFgbbKwnb9MLmUQDhG6")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 18 entries:
  :album         => {…
  :artists       => JSON3.Object[{…
  :disc_number   => 1
  :duration_ms   => 65314
  :explicit      => true
  :external_ids  => {…
  :external_urls => {…
```
"""
function tracks_get_single(track_id; market::String="US")
    return spotify_request("tracks/$track_id?market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-tracks

"""
    tracks_get_multiple(ids::String; market::String="US")

**Summary**: Get Spotify catalog information for multiple tracks based on their Spotify IDs.

# Arguments
- `ids` : A comma-separated list of the Spotify IDs.

# Optional keywords
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".

# Example
```julia-repl
julia> Spotify.tracks_get_multiple("4iV5W9uYEdYUVa79Axb7Rh,1301WleyT98MSxVHPZCA6")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :tracks => Union{Nothing, JSON3.Object}[{…
```
"""
function tracks_get_multiple(ids; market::String="US")
    return spotify_request("tracks?ids=$ids&market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-tracks

"""
    tracks_get_saved(;limit::Int64=20, market::String="US", offset::Int64=0)

**Summary**: Get a list of the songs saved in the current Spotify user's 'Your Music' library.

# Optional keywords
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> Spotify.tracks_get_saved()[1]
[ Info: We try requests without checking if current grant includes the necessary scope, which is: user-library-read.
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/tracks?offset=0&limit=20&market=US"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/me/tracks?offset=20&limit=20&market=US"
```
"""
function tracks_get_saved(;limit::Int64=20, market::String="US", offset::Int64=0)
    return spotify_request("me/tracks?limit=$limit&market=$market&offset=$offset";
                           scope = "user-library-read")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-tracks

"""
    tracks_get_contains(ids)

**Summary**: Check if one or more tracks is already saved in the current Spotify user's 'Your Music' library.

# Arguments
- `ids` : A comma-separated list of the Spotify track IDs.

# Example
```julia-repl
julia> Spotify.tracks_get_contains("4iV5W9uYEdYUVa79Axb7Rh, 4VqPOruhp5EdPBeR92t6lQ")[1]
2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
 0
```
"""
function tracks_get_contains(ids)
    return spotify_request("me/tracks/contains?ids=$ids"; scope = "user-library-read")
end