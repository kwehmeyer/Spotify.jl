![](/docs/src/assets/logo.png)



 [![Docs](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml/badge.svg)](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml) 
![example workflow](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/CI.yaml/badge.svg) 

[Code coverage report](https://htmlpreview.github.io/?https://github.com/vnegi10/Spotify.jl/blob/gh-pages/coverage/index.html)

# An open-source interface for using the Spotify web API in Julia. 



## Progress...
Right now, 65 API wrapper functions and 12 aliases have been written, tested and organized by sub-modules as defined in Spotify's [documentation](https://developer.spotify.com/documentation/general/):

## What can you use this for?

You can 
  * play music through a mini-player REPL mode
  * organize playlists based on audio analysis or each track's popularity in Japan
  * control your music bias with the algorithm 
  * build various social graphs or analyze statistics
  * clean duplicates, tracks or you've come to dislike from all your playlists and the library
  * search podcast metadata, cont podcast
  * create your own visualizations from beat data
  * make player interfaces

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


## Documentation and a bref example

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

# To Do
* [x] Inline Documentation needs to be completed
* [x] Wiki 
* [x] Write tests
* [x] Set up CI
* [x] Register the package