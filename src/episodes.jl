# episodes.jl
## https://developer.spotify.com/documentation/web-api/reference/episodes/

## https://developer.spotify.com/documentation/web-api/reference/episodes/get-an-episode/

function episodes_get(episode_id, market="US")
    return spotify_request("episodes/$episode_id?market=$market")
end
