![](/docs/src/assets/logo.png)



 [![Docs](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml/badge.svg)](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml) 
![example workflow](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/CI.yaml/badge.svg) 

[Code coverage report](https://htmlpreview.github.io/?https://github.com/vnegi10/Spotify.jl/blob/gh-pages/coverage/index.html)

# An open-source interface for using the Spotify web API in Julia. 



## Progress...
Right now, mostly all endpoint wrapper functions have been written, tested and organized by sub-modules as defined in Spotify's [documentation](https://developer.spotify.com/documentation/web-api). The documentation was [reworked](https://developer.spotify.com/blog/2023-03-27-introducing-the-new-spotify-for-developers) in March 2023, but most documentation links still work.

Any missing endpoints, e.g. 'queue', 'repeat', 'volume' and 'shuffle', could be accessed more directly through calls like `spotify_request("recommendations/available-genre-seeds")`.

## What can you use this for?

You can 
  * play music and prune your playlists through a mini-player REPL mode
  * organize playlists based on audio analysis or each track's popularity in Japan
  * fix your taste profile after that kid's party 
  * build social graphs for artists, playlists or users, analyze popularity
  * clean duplicates
  * search podcast metadata
  * create your own visualizations from beat data
  * play with popularity and genre statistics

Easily find the right functions with the `select_calls` menu and the submodules:

* Albums, Artists, Categories, Episodes, Genres,
* Library, Markets, Player, Playlists, Search
* Shows, Tracks, Users, Profile

## Getting started

Loading:

```julia-repl
(@v1.8) pkg> add Spotify

julia> using Spotify
```

This creates 'spotify_credentials.ini' in your `homedir()`, along with instructions on how to input your user name and client credentials.

```julia-repl
julia> select_calls()
```

This brings up a menu for exploration calls, which works best in the REPL. 


## Wrapper API

Wrapper functions require different permission scopes, which you grant as needed by pressing 'Accept' in a browser tab which pops up when needed. A granted scope lasts for one hour.

The wrapper functions are duck-typed and will accept strings, vectors of strings or the types below. 
Functions leniently convert input to these string-like types:

* `SpPlaylistId`, `SpArtistId`, `SpTrackId`, `SpAlbumId`
* `SpShowId`, `SpEpisodeId`, `SpId`, `SpCategoryId` 

Ouput from all wrapper functions is a tuple: (`JSON3 object`, `wait_seconds`). 

* `wait_seconds` is zero except if the API rate limit is temporarily exceeded
* `JSON3 object` is an `object` / `dictionary` which is easy and fast to inspect and use. See the examples for some ideas

Control of text feedback is provided, see `?LOGSTATE`.


## Documentation and a brief example

For more detail on setting up your credentials and getting keys please checkout [this page in the documentation](https://kwehmeyer.github.io/Spotify.jl/dev/authentication.html#Obtaining-API-Keys).

```julia
julia> using Spotify, Spotify.Tracks
julia> tracks_get_audio_features("5gZ5YB5SryZdM0GV7mXzDJ")
({
       "danceability": 0.636,
             "energy": 0.699,
                "key": 4,
           "loudness": -7.602,
               "mode": 1,
        "speechiness": 0.0332,
       "acousticness": 0.0297,
   "instrumentalness": 0.0174,
           "liveness": 0.098,
            "valence": 0.964,
              "tempo": 102.019,
               "type": "audio_features",
                 "id": "5gZ5YB5SryZdM0GV7mXzDJ",
                "uri": "spotify:track:5gZ5YB5SryZdM0GV7mXzDJ",
         "track_href": "https://api.spotify.com/v1/tracks/5gZ5YB5SryZdM0GV7mXzDJ",
       "analysis_url": "https://api.spotify.com/v1/audio-analysis/5gZ5YB5SryZdM0GV7mXzDJ",
        "duration_ms": 214267,
     "time_signature": 3
}, 0)
```

## Usage as a dependency 

If you are using this package from your own module, turning off default authorization will save startup time.

From version 0.2.1, authorization during compilation (and possibly precompilation in a separate thread!) can be disabled by setting the environment variable SPOTIFY_NOINIT. 

```julia
julia> push!(ENV, "SPOTIFY_NOINIT" => "true"); using Spotify

julia> scopes = ["user-read-private", "user-modify-playback-state", "user-read-playback-state", "playlist-modify-private",
        "playlist-read-private", "playlist-read-collaborative", "user-library-read"];
julia> if ! Spotify.credentials_contain_scope(scopes)
               apply_and_wait_for_implicit_grant(;scopes)
           end
[ Info: Negotiating client credentials, which typically last 1 hour.
┌ Info: Client credentials expire in 3600 seconds.
│           You can inspect with `Spotify.spotcred()`, `Spotify.expiring_in()`,
└            or e.g. `Spotify.credentials_contain_scope("user-read-private")`
        Listening for user authorization through browser on 127.0.0.1:8080 and path /api
        Launching a browser at: https://accounts.spotify.com/authorize?client_id=...

[ Info: Received implicit grant token expires in 3600 seconds
[ Info: Successfully retrieved grant of these scopes: ["user-read-private", "user-modify-playback-state", "user-read-playback-state", "playlist-modify-private", "playlist-read-private", "playlist-read-collaborative", "user-library-read"]
(Task (done) @0x000002324fffe8c0, Task (done) @0x000002324fffe2f0)
```


# To Do
* [x] Inline Documentation needs to be completed
* [x] Wiki 
* [x] Write tests
* [x] Set up CI
* [x] Register the package