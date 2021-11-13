![](/docs/src/assets/logo.png)
      

An open-source interface for using the Spotify web API in Julia. 

[![Docs](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml/badge.svg)](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/builddoc.yml)
![example workflow](https://github.com/kwehmeyer/Spotify.jl/actions/workflows/CI.yaml/badge.svg)

## Progress...
Right now, 40 API functions have been written, roughly tested and organized by sub-modules as defined in Spotify's [documentation](https://developer.spotify.com/documentation/general/):

* Albums, Artists, Browse, Episodes, Follow, Library
* Markets, Personalization, Player, Playlists, Search
* Shows, Tracks, UsersProfile, ~~(Objects)~~

Help wanted in adding the still-missing functions!

Ouput from function calls is JSON3 objects, which can be readily manipulated in the REPL or in other packages.

Input to all functions is basically strings, but some ad-hoc string types are defined. These provide potential input checking, and some assistance in finding dummy parameters. Dummy parameters are defined in the 'test' folder, but more accessible through the menu system, see below.

## Example use

    using Julia

This creates 'spotify_credentials.ini' in your `homedir()`, along with brief instructions on how to configure your 'client credentials'.

For repetitive debugging, the quickest syntax is (this function uses the low-level 'Client credentials' scope):

```julia
julia> include("test/interactive_default_calls.jl")
[ Info: Retrieving client credentials, which typically lasts 1 hour.
[ Info: Expires at 2021-04-26T11:17:59.009. Access `spotcred()`, refresh with `refresh_spotify_credentials()`.
show_default_call (generic function with 2 methods)
pick_function (generic function with 1 method)

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

For those of us who don't remember function numbers, there's an interactive menu (not part of the package as such):

```julia

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

julia> using Spotify.Follow

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
└ @ Spotify C:\Users\frohu_h4g8g6y\.julia\dev\Spotify.jl\src\util\utilities.jl:20
()

Response after 496 milliseconds


julia>
        Implicit grant token expires at 2021-04-26T17:40:10.987 - closing server
julia>

```
When you try this yourself, we hope you appreciate the colors! You noticed how we were kicked out of the menu system because the 'Client credentials' were not sufficient here? We clicked 'Accept' in the browser that popped up, and we got a higher permission for the next hour. 

Now we could `pick_function()` again, but let's call the function directly with an interesting artist, 'Chinese man'!

```julia


julia> strip_embed_code("""<iframe src="https://open.spotify.com/embed/artist/6vgw0jwJkUnW2NR1rzsQU3" width="300" height="380" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>""")
"6vgw0jwJkUnW2NR1rzsQU3"

julia> # We copy the function call from above, but replace the embed code with what we just found:

julia> follow_check("artist", "6vgw0jwJkUnW2NR1rzsQU3")
[ Info: user-follow-read
[ Info: We just try without checking if grant includes scope user-follow-read.
1-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 1

julia> ans[1]
true

julia> # Yes, I follow this artist
```



# To Do
* Inline Documentation needs to be completed
* [x] Wiki 
* [ ] Write tests --> In progress
* [ ] Set up CI
* [x] Register the package  

