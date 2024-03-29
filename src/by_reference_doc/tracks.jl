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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-analysis)
"""
function tracks_get_audio_analysis(track_id)
    tid = SpTrackId(track_id)
    spotify_request("audio-analysis/$tid")
end


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
## acousticness
A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.

## analysis_url
A URL to access the full audio analysis of this track. An access token is required to access this data.

## danceability
Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.

## duration_ms
The duration of the track in milliseconds.

## energy
Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.

## id
The Spotify ID for the track.

## instrumentalness
Predicts whether a track contains no vocals. "Ooh" and "aah" sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly "vocal". The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0.

## key
>= -1, <= 11
The key the track is in. Integers map to pitches using standard Pitch Class notation. E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. If no key was detected, the value is -1.

## liveness
Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live.

## loudness
The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typically range between -60 and 0 db.

## mode
Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0.

## speechiness
Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.

## tempo
The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration.

## time_signature
>= 3, <= 7
An estimated time signature. The time signature (meter) is a notational convention to specify how many beats are in each bar (or measure). The time signature ranges from 3 to 7 indicating time signatures of "3/4", to "7/4".

## track_href
A link to the Web API endpoint providing full details of the track.

## type
The object type. Allowed value: "audio_features"

## uri
The Spotify URI for the track.

## valence
>= 0, <= 1
A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features)
"""
function tracks_get_audio_features(track_id)
    tid = SpTrackId(track_id)
    spotify_request("audio-features/$tid")
end


"""
    tracks_get(track_id; market = "")

**Summary**: Get a spotify catalog information for a single track identified by it's unique Spotify ID.

# Arguments
- `track_id` : The Spotify ID for the track.

# Optional keywords
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.

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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track)
"""
function tracks_get_single(track_id; market = "")
    tid = SpTrackId(track_id)
    u = "tracks/$tid"
    a = urlstring(; market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    tracks_get_multiple(track_ids, market = "")

**Summary**: Get Spotify catalog information for multiple tracks based on their Spotify IDs.

# Arguments
- `track_ids` : A comma-separated list of the Spotify IDs.

# Optional keywords
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.

# Example
```julia-repl
julia> tracks_get_multiple(["7ouMYWpwJ422jRcDASZB7P", "4VqPOruhp5EdPBeR92t6lQ", "2takcwOaAZWiXQijPHIx7B"])[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :tracks => Union{Nothing, JSON3.Object}[{…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-tracks)
"""
function tracks_get_multiple(track_ids; market = "")
    ids = SpTrackId.(track_ids)
    u = "tracks"
    a = urlstring(; ids, market)
    url = build_query_string(u, a)
    spotify_request(url)
end


"""
    tracks_get_saved(;limit = 20, market = "", offset = 0)

**Summary**: Get a list of the songs saved in the current Spotify user's 'Your Music' library.

# Optional keywords
- `limit`          : Maximum number of items to return, default is set to 20
- `market`         : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.
- `offset` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> tracks_get_saved()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/tracks?offset=0&limit=20&market=US"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/me/tracks?offset=20&limit=20&market=US"
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-tracks)
"""
function tracks_get_saved(;limit = 20, market = "", offset = 0)
    u = "me/tracks"
    a = urlstring(; market, offset)
    url = build_query_string(u, a)
    spotify_request(url, scope = "user-library-read")
end


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

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-tracks)
"""
function tracks_get_contains(track_ids)
    ids = SpTrackId.(track_ids)
    u = "me/tracks/contains"
    a = urlstring(; ids)
    url = build_query_string(u, a)
    spotify_request(url, scope = "user-library-read")
end


"""
    tracks_get_recommendations(seeds_dict::Dict;
        track_attributes::Dict = Dict{String, String}(), limit = 50, market = "")

**Summary**: Get Recommendations based on Seeds

# Optional keywords
- `seeds_dict`       : A dictionary containing keys (seed_genres, seed_artists, seed_tracks) and values for each key being seeds
         delimited by a comma up to 5 seeds for each category.
        Up to 5 seed values may be provided in any combination of seed_artists, seed_tracks and seed_genres.
            For example:
         Dict("seed_artists" => "s33dart1st,s33edart!st2", "seed_genres" => "g3nre1,genr32", "seed_tracks" => "trackid1,trackid2")
- `track_attributes` : A dictionary containing key values for ≈ 50 tunable track track_attributes, see reference.
- `limit`            : Maximum number of items to return, default is set to 20
- `market`           : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                     only episodes that are available in that market will be returned.

# Reference
- (https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendations)

# Example
```julia-repl
julia> seeds_dict = Dict("seed_artists" => "0YC192cP3KPCRWx8zr8MfZ")
Dict{String, String} with 1 entry:
  "seed_artists" => "0YC192cP3KPCRWx8zr8MfZ"

julia> track_attributes = Dict("max_danceability" => "0.80")
Dict{String, String} with 1 entry:
  "max_danceability" => "0.80"

julia> tracks_get_recommendations(seeds_dict; track_attributes)[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 2 entries:
  :tracks => JSON3.Object[{…
  :seeds  => JSON3.Object[{…
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendations)
"""
function tracks_get_recommendations(seeds_dict::Dict;
                              track_attributes::Dict = Dict{String, String}(), limit = 50, market = "")
    u = "recommendations"
    a1 = urlstring(seeds_dict)
    a2 = urlstring(track_attributes)
    a3 = urlstring(;limit, market)
    url = build_query_string(u, a1, a2, a3)
    spotify_request(url)
end


"""
    tracks_remove_from_library(track_ids)

**Summary**: Remove one or more tracks for the current user's 'Your Music' library.

`track_ids` _Required_: A comma-separated list of the Spotify IDs. Maximum 50.

# Example
```
julia> tracks_remove_from_library(["0WdUHon5tYn2aKve13psfy", "619OpJGKpAOrp5rM4Gcs65"])[1]
{}
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/remove-tracks-user/)
"""
function tracks_remove_from_library(track_ids)
    method = "DELETE"
    ids = SpTrackId.(track_ids)
    u = "me/tracks"
    a = urlstring(; ids)
    url = build_query_string(u, a)
    spotify_request(url, method; scope = "user-library-modify")
end


"""
    tracks_save_library(track_ids)

** Summary**: Save one or more tracks to the current user's 'Your Music' library.

`track_ids` _Required_: A comma-separated list of Spotify IDs. Maximum 50.

# Example
```
julia> tracks_save_library(["0WdUHon5tYn2aKve13psfy", "619OpJGKpAOrp5rM4Gcs65"])[1]
{}
```

[Reference](https://developer.spotify.com/documentation/web-api/reference/library/save-tracks-user/)
"""
function tracks_save_library(track_ids)
    method = "PUT"
    ids = SpTrackId.(track_ids)
    u = "me/tracks"
    a = urlstring(; ids)
    url = build_query_string(u, a)
    spotify_request(url, method; scope = "user-library-modify")
end

