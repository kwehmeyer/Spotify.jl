# episodes.jl
## https://developer.spotify.com/documentation/web-api/reference/episodes/

## https://developer.spotify.com/documentation/web-api/reference/episodes/get-an-episode/
@doc """
# Get an Episode
**Summary**: Get Spotify catalog information for a single peisode identified by it's unique Spotify ID.\n 

`episode_id` _Required_: The Spotify ID for the episode_id. Up to 50 episodes can be passed, comma delimited.\n
`market` _Optional_: An ISO 3166-1 alpha 2 country code.

[Reference](https://developer.spotify.com/documentation/web-api/reference/episodes/get-an-episode/)
""" ->
function episodes_get(episode_id, market="US")
    return spotify_request("episodes/$episode_id?market=$market")
end
