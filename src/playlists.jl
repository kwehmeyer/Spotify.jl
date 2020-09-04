# playlists.jl
## https://developer.spotify.com/documentation/web-api/reference/playlists/

#### POST #####

## https://developer.spotify.com/documentation/web-api/reference/playlists/add-tracks-to-playlist/

function playlists_add_tracks(playlist_id, uris, position=0)
    return spotify_request("playlists/$playlist_id/tracks?uris=$uris&position=$position", method="POST")
end

## https://developer.spotify.com/documentation/web-api/reference/playlists/create-playlist/

# !INCOMPLETE

function playlists_create_playlist(user_id, p_name, p_description, public="true", collaborative="false")
    playlist_details = Dict("name"=>p_name,
        "description"=>p_description,
        "public"=>public,
        "collaborative"=> collaborative)
    playlist_details = JSON.json(playlist_details) # TODO: This needs to be sent as the body
    return spotify_request("users/$user_id/playlists")
end

#### DELETE ####

## https://developer.spotify.com/documentation/web-api/reference/playlists/remove-tracks-playlist/

function playlists_delete(playlist_id, )
