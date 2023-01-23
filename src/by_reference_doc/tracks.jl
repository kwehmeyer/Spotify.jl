## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-analysis

"""
    tracks_get_audio_analysis(track_id)

**Summary**: Get a detailed audio analysis for a single track identified by it's unique Spotify ID.

# Arguments
- `track_id`: The Spotify ID for the track

# Example
```julia-repl
julia> tracks_get_audio_analysis("6rqhFgbbKwnb9MLmUQDhG6")[1]
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
julia> tracks_get_audio_features("6rqhFgbbKwnb9MLmUQDhG6")[1]
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

# Result parameters
acousticness
A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.

analysis_url
A URL to access the full audio analysis of this track. An access token is required to access this data.

danceability
Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.

duration_ms
The duration of the track in milliseconds.

energy
Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.

id
The Spotify ID for the track.

instrumentalness
Predicts whether a track contains no vocals. "Ooh" and "aah" sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly "vocal". The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0.

key
>= -1, <= 11
The key the track is in. Integers map to pitches using standard Pitch Class notation. E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. If no key was detected, the value is -1.

liveness
Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live.

loudness
The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typically range between -60 and 0 db.

mode
Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0.

speechiness
Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.

tempo
The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration.

time_signature
>= 3, <= 7
An estimated time signature. The time signature (meter) is a notational convention to specify how many beats are in each bar (or measure). The time signature ranges from 3 to 7 indicating time signatures of "3/4", to "7/4".

track_href
A link to the Web API endpoint providing full details of the track.

type
The object type. Allowed value: "audio_features"

uri
The Spotify URI for the track.

valence
>= 0, <= 1
A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).
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
julia> tracks_get("6rqhFgbbKwnb9MLmUQDhG6")[1]
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
function tracks_get_single(track_id; market="")
    return spotify_request("tracks/$track_id?market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-tracks

"""
    tracks_get_multiple(ids; market="")

**Summary**: Get Spotify catalog information for multiple tracks based on their Spotify IDs.

# Arguments
- `ids` : A comma-separated list of the Spotify IDs.

# Optional keywords
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".

# Example
```julia-repl
julia> tracks_get_multiple("4iV5W9uYEdYUVa79Axb7Rh,1301WleyT98MSxVHPZCA6")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :tracks => Union{Nothing, JSON3.Object}[{…
```
"""
function tracks_get_multiple(ids; market="")
    return spotify_request("tracks?ids=$ids&market=$market")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-tracks

"""
    tracks_get_saved(;limit=20, market="", offset::Int64=0)

**Summary**: Get a list of the songs saved in the current Spotify user's 'Your Music' library.

# Optional keywords
- `limit`          : Maximum number of items to return, default is set to 20
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
                     Default is set to "US".
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> tracks_get_saved()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/tracks?offset=0&limit=20&market=US"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/me/tracks?offset=20&limit=20&market=US"
```
"""
function tracks_get_saved(;limit=20, market="", offset::Int64=0)
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
julia> tracks_get_contains("4iV5W9uYEdYUVa79Axb7Rh, 4VqPOruhp5EdPBeR92t6lQ")[1]
2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
 0
```
"""
function tracks_get_contains(ids)
    return spotify_request("me/tracks/contains?ids=$ids"; scope = "user-library-read")
end

## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendations
"""
    tracks_get_recommendations(seeds; track_attributes, limit = 50, market = "")

**Summary**: Get Recommendations Based on Seeds

# Optional keywords
- `seeds_dict` : A dictionary containing keys (seed_genres, seed_artists, seed_tracks) and values for each key being seeds
         delimited by a comma up to 5 seeds for each category. 
        Up to 5 seed values may be provided in any combination of seed_artists, seed_tracks and seed_genres.
            For example:
         Dict("seed_artists" => "s33dart1st,s33edart!st2", "seed_genres" => "g3nre1,genr32", "seed_tracks" => "trackid1,trackid2")
- `track_attributes_dict` : A dictionary containing key values for ≈ 50 tunable track track_attributes, see reference.
- `limit`         : Maximum number of items to return, default is set to 20
- `market`        : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.

# Reference
- (https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendations)

# Example
```julia-repl
julia> seeds_dict = Dict("seed_artists" => "0YC192cP3KPCRWx8zr8MfZ")
Dict{String, String} with 1 entry:
  "seed_artists" => "0YC192cP3KPCRWx8zr8MfZ"

julia> track_attributes_dict = Dict("max_danceability" => "0.80")
Dict{String, String} with 1 entry:
  "max_danceability" => "0.80"

julia> tracks_get_recommendations(seeds_dict; track_attributes_dict)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 2 entries:
  :tracks => JSON3.Object[{…
  :seeds  => JSON3.Object[{…
```
"""
function tracks_get_recommendations(seeds_dict::Dict; 
                              track_attributes_dict = Dict{String, String}(), limit=50, market="")
    url = "recommendations?" 
    url1 = urlstring(seeds_dict)
    url2 = urlstring(track_attributes_dict)
    url3 = urlstring(; limit, market)
    url *= join([url1, url2, url3], "&")
    return spotify_request(url)
end
