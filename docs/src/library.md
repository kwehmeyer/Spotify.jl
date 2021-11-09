# Library API

```@contents
Pages = ["library.md"]
```
## For getting information about you (current user)
Endpoints referenced [here](https://developer.spotify.com/console/library/) are included in the library section.
These functions act on whoever has authorized their account to be queried. They can answer questions like

> What are your saved show/tracks/albums

> Let's save or unsave albums


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "library") == true
Private = true
```