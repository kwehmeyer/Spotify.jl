# Spotify.jl
## A simple Spotify API Wrapper in Julia

!!! warning "In Progress"
    This package and the accompanying documentation is still under development


`Spofity.jl` aims to create a simple interface with the Spotify API to provide Julia users with Spotify data.

## Use Cases
* Create your own recommendation algorithm
* Dashboards for music listening habits
* Analyze audio features for music you enjoy
* Automatically create playlists
* Create applications to augment your music experience


We are excited to complete the project and see what people can create using `Spotify.jl'

## In progress

Right now, 40 API functions have been written, roughly tested and organized by sub-modules as defined in Spotify's documentation:

Albums, Artists, Browse, Episodes, Follow, Library
Markets, Personalization, Player, Playlists, Search
Shows, Tracks, UsersProfile, (Objects)
Help wanted in adding the still-missing functions!

Ouput from function calls is JSON3 objects, which can be readily manipulated in the REPL or in other packages.

Input to all functions is basically strings, but some ad-hoc string types are defined. These provide potential input checking, and some assistance in finding dummy parameters. Dummy parameters are defined in the 'test' folder, but more accessible through the menu system, see below.