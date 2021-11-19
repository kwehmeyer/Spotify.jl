![](/docs/src/assets/logo.png)



 [![Docs](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml/badge.svg)](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml) 
![example workflow](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/CI.yaml/badge.svg) 

[Code coverage report](https://htmlpreview.github.io/?https://github.com/vnegi10/Spotify.jl/blob/gh-pages/coverage/index.html)

# An open-source interface for using the Spotify web API in Julia. 



## Progress...
Right now, 40 API functions have been written, roughly tested and organized by sub-modules as defined in Spotify's [documentation](https://developer.spotify.com/documentation/general/):

* Albums, Artists, Browse, Episodes, Follow, Library
* Markets, Personalization, Player, Playlists, Search
* Shows, Tracks, UsersProfile, ~~(Objects)~~

Help wanted in adding the still-missing functions!

Ouput from function calls is JSON3 objects, which can be readily manipulated in the REPL or in other packages.

Input to all functions is basically strings, but some ad-hoc string types are defined. These provide potential input checking, and some assistance in finding dummy parameters. Dummy parameters are defined in the 'test' folder, but more accessible through the menu system, see below.

## Example use
### Installation
The latest build can be installed via the registry 
```julia
(@v1.6) pkg> add Spotify
```

    using Spotify

This creates 'spotify_credentials.ini' in your `homedir()`, along with brief instructions on how to configure your 'client credentials'.

For repetitive debugging, the quickest syntax is (this function uses the low-level 'Client credentials' scope):

For more detail on setting up your credentials and getting keys please checkout [this page in the documentation](https://kwehmeyer.github.io/Spotify.jl/dev/authentication.html#Obtaining-API-Keys).

```julia
julia> Spotify.tracks_get_audio_features("5gZ5YB5SryZdM0GV7mXzDJ")
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
* [ ] Write tests --> In progress
* [x] Set up CI
* [x] Register the package  

