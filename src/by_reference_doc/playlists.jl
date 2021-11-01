## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks

"""
    playlist_get_tracks(playlist_id::String; additional_types="track", limit=50, 
    offset=0, market="US")

**Summary**: Get details about the items of a playlist.

# Arguments
- `playlist_id::String` : Alphanumeric ID of the playlist

# Optional keywords
- `additional_types::String` : "track" (default) or "episode"
- `fields::String` : Filters for the query, a comma-separated list of the fields to return.
                     For example, to get just the added date and user ID of the adder, 
                     fields = "items(added_at,added_by.id)". Default is set to "", which means
                     all fields are returned.
- `limit::Int64` : Maximum number of items to return, default is set to 20
- `offset::Int64` : Index of the first item to return, default is set to 0
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified, 
                     only episodes that are available in that market will be returned. 
                     Default is set to "US".

# Example
```julia-repl
julia> Spotify.playlist_get_tracks("37i9dQZF1E4vUblDJbCkV3")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/playlists/37i9dQZF1E4vUblDJbCkV3/tracks?offset=0&limit=20&market=US&additional_types=…
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/playlists/37i9dQZF1E4vUblDJbCkV3/tracks?offset=20&limit=20&market=US&additional_types…
  :offset   => 0
  :previous => nothing
  :total    => 50
```    
"""
function playlist_get_tracks(playlist_id::String; additional_types::String="track", fields::String="",
                             limit::Int64=20, offset::Int64=0, market::String="US")

    url1 = "playlists/$(playlist_id)/tracks?additional_types=$additional_types"
    url2 = "&fields=$fields&limit=$limit&offset=$offset&market=$market"

    return Spotify.spotify_request(url1*url2)

end