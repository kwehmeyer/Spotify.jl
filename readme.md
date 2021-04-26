# Spotify.jl
An open-source interface for using the Spotify web API in Julia. 

## Progress...
Right now, 40 API functions have been writte, roughly tested and organized by sub-modules as defined in Spotify's [documentation](https://developer.spotify.com/documentation/general/):
* Albums, Artists, Browse, Episodes, Follow, Library
* Markets, Personalization, Player, Playlists, Search
* Shows, Tracks, UsersProfile, Objects

Help wanted in adding the still-missing functions!

Ouput from function calls is JSON3 objects, which can be readily manipulated in the REPL or in other packages.

Input to all functions is basically strings, but some ad-hoc string types are defined. These provide potential input checking, and some assistance in finding dummy parameters. Dummy parameters are defined in the 'test' folder.

## Example use

    using Julia

This creates 'spotify_credentials.in' in your home directory, along with brief instructions on how to configure your 'client credentials'.

For repetitive debugging, the quickest syntax is (this function uses the low-level 'Client credentials' scope):
```julia
julia> include("test/generalize_calls.jl")
[ Info: Retrieving client credentials, which typically lasts 1 hour.
[ Info: Expires at 2021-04-26T11:17:59.009. Access `spotcred()`, refresh with `refresh_spotify_credentials()`.
show_default_call (generic function with 2 methods)

julia> using Spotify.Artists

julia> make_default_call(3)
[ Info: client-credentials
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 10 entries:
  :external_urls => {…
  :followers     => {…
  :genres        => ["afrobeat", "afropop", "ethio-jazz", "funk", "world"]
  :href          => "https://api.spotify.com/v1/artists/7HGFXtBhRq3g1Ma3nH4Rgv"
  :id            => "7HGFXtBhRq3g1Ma3nH4Rgv"
  :images        => JSON3.Object[{…
  :name          => "Mulatu Astatke"
  :popularity    => 55
  :type          => "artist"
  :uri           => "spotify:artist:7HGFXtBhRq3g1Ma3nH4Rgv"

julia> 

```

Irritatingly, this puts you in the 'test' folder, so: `cd("..")` to get back.

For those of us who don't remember function numbers, there's an interactive menu, useful for configuring your setup and finding out which submodules to load.

```julia
julia> include("test/interactive_default_calls.jl")
pick_function (generic function with 1 method)

julia> using Spotify.Artists, Spotify.Follow

julia> pick_function()
Pick group (red: module not loaded)
[press: d=done, a=all, n=none]
   ⬚ 1:2         Albums
 → ✓ 3:6         Artists
   ⬚ 7:13        Browse
   ⬚ 14:14       Episodes
   ⬚ 15:21       Follow
   ⬚ 22:33       Library
   ⬚ 34:35       Personalization
   ⬚ 36:37       Player
   ⬚ 38:40       Playlists
Pick function
[press: enter = select, q=quit]
 →  3 :(artist_get(7HGFXtBhRq3g1Ma3nH4Rgv))
    4 :(artist_get_albums(7HGFXtBhRq3g1Ma3nH4Rgv, "album,single,appears_on,compilation", "NO", 10, 0))
    5 :(artist_top_tracks(7HGFXtBhRq3g1Ma3nH4Rgv, "NO"))
    6 :(artist_get_related_artists(7HGFXtBhRq3g1Ma3nH4Rgv))

Now calling:
          :(artist_get(7HGFXtBhRq3g1Ma3nH4Rgv))
[ Info: client-credentials
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 10 entries:
  :external_urls => {…
  :followers     => {…
  :genres        => ["afrobeat", "afropop", "ethio-jazz", "funk", "world"]
  :href          => "https://api.spotify.com/v1/artists/7HGFXtBhRq3g1Ma3nH4Rgv"
  :id            => "7HGFXtBhRq3g1Ma3nH4Rgv"
  :images        => JSON3.Object[{…
  :name          => "Mulatu Astatke"
  :popularity    => 55
  :type          => "artist"
  :uri           => "spotify:artist:7HGFXtBhRq3g1Ma3nH4Rgv"

Response after 305 milliseconds

Pick function
[press: enter = select, q=quit]
 →  3 :(artist_get(7HGFXtBhRq3g1Ma3nH4Rgv))
    4 :(artist_get_albums(7HGFXtBhRq3g1Ma3nH4Rgv, "album,single,appears_on,compilation", "NO", 10, 0))
    5 :(artist_top_tracks(7HGFXtBhRq3g1Ma3nH4Rgv, "NO"))
    6 :(artist_get_related_artists(7HGFXtBhRq3g1Ma3nH4Rgv))

julia> 
```

When you try this yourself, we hope you appreciate the colors! 'Artist' and 'Follow'
were highlighted.
A the end, there, we pressed 'q' to quit. But what about the 'Follow' module?
Those functions require a higher authority, so while reading the following example you need to imagine a web-browser asyncronously popping up in front of you, and you clicking accept!

Let's restart the menu:
```julia

julia> pick_function()
Pick group (red: module not loaded)
[press: d=done, a=all, n=none]
   ⬚ 1:2         Albums
   ⬚ 3:6         Artists
   ⬚ 7:13        Browse
   ⬚ 14:14       Episodes
 → ✓ 15:21       Follow
   ⬚ 22:33       Library
   ⬚ 34:35       Personalization
   ⬚ 36:37       Player
   ⬚ 38:40       Playlists
Pick function
[press: enter = select, q=quit]
 → 15 :(follow_check("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   16 :(follow_check_playlist(5o5IGyk4tKO7A0DkVpstN0, 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   17 :(follow_artists("artist", 10))
   18 :(follow_artists_users("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))      
   19 :(follow_playlist(5o5IGyk4tKO7A0DkVpstN0))
   20 :(unfollow_artists_users("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))    
   21 :(unfollow_playlist(5o5IGyk4tKO7A0DkVpstN0))

Now calling:
          :(follow_check("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
[ Info: user-follow-read
[ Info: Starting asyncronous user authorization process. Try again later!
        Listening for authorization on 127.0.0.1:8080 and path /api
        Launching a browser at: https://accounts.spotify.com/authorize?client_id=d972bafe04d34e98ab22f5d2bd7751b8&redirect_uri=http:%2F%2F127.0.0.1:8080%2Fapi&scope=user-read-private%20user-read-email%20user-follow-read&show_dialog=true&response_type=token&state=987
        Trying to launch browser candidate: firefox
┌ Warning: Current scope not valid, exiting call: user-follow-read
└ @ Spotify c:\Users\frohu_h4g8g6y\.julia\dev\Spotify\src\util\utilities.jl:20
()

Response after 522 milliseconds


julia> 

        Implicit grant token expires at 2021-04-26T11:34:20.161 - closing server

julia> pick_function()
Pick group (red: module not loaded)
[press: d=done, a=all, n=none]
   ⬚ 1:2         Albums
   ⬚ 3:6         Artists
   ⬚ 7:13        Browse
   ⬚ 14:14       Episodes
 → ✓ 15:21       Follow
   ⬚ 22:33       Library
   ⬚ 34:35       Personalization
   ⬚ 36:37       Player
   ⬚ 38:40       Playlists
Pick function
[press: enter = select, q=quit]
 → 15 :(follow_check("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   16 :(follow_check_playlist(5o5IGyk4tKO7A0DkVpstN0, 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   17 :(follow_artists("artist", 10))
   18 :(follow_artists_users("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   19 :(follow_playlist(5o5IGyk4tKO7A0DkVpstN0))
   20 :(unfollow_artists_users("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   21 :(unfollow_playlist(5o5IGyk4tKO7A0DkVpstN0))

Now calling:
          :(follow_check("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
[ Info: user-follow-read
[ Info: We just try without checking if grant includes scope user-follow-read.
2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 0
 0

Response after 312 milliseconds

Pick function
[press: enter = select, q=quit]
 → 15 :(follow_check("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   16 :(follow_check_playlist(5o5IGyk4tKO7A0DkVpstN0, 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   17 :(follow_artists("artist", 10))
   18 :(follow_artists_users("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   19 :(follow_playlist(5o5IGyk4tKO7A0DkVpstN0))
   20 :(unfollow_artists_users("artist", 74ASZWbe4lXaubB36ztrGX, 08td7MxkoHQkXnWAYD8d6Q))
   21 :(unfollow_playlist(5o5IGyk4tKO7A0DkVpstN0))
```

# To Do
* Inline Documentation needs to be completed
* Wiki
* Write tests
* Set up CI
* Register the package  