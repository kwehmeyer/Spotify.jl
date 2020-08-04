# tracks.jl
## https://developer.spotify.com/documentation/web-api/reference/tracks/


## https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-analysis/
@doc """
# Get Audio Analysis for a Track 
**Summary**: Get a detailed audio analysis for a single track identified by it's unique Spotify ID.

`track_id` _Required_: The Spotify ID for the track.

[Reference](https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-analysis/)
""" ->
function tracks_get_audio_analysis(track_id)
    return spotify_request("audio-analysis/$track_id")
end




## https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-features/
@doc """
# Get Audio Features for a Track
**Summary**: Get audio feature information for a single track identified by it's unique Spotify ID

`track_id` _Required_: The Spotify ID for the track.

[Reference](https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-features/)
""" ->
function tracks_get_audio_features(track_id)
    return spotify_request("audio-features/$track_id")
end



## https://developer.spotify.com/documentation/web-api/reference/tracks/get-track/
@doc """
# Get a Track
**Summary**: Get a spotify catalog information for a single track identified by it's unique Spotify ID

`track_id` _Required_: The Spotify ID for the track. Up to 50 tracks can be passed seperated with a comma. No whitespace.\n
`market` _Optional_: An ISO 3166=1 alpha-2 country code

[Reference](https://developer.spotify.com/documentation/web-api/reference/tracks/get-track/)
"""
function tracks_get(track_id, market="US")
    return spotify_request("tracks/$track_id?market=$market")
end




