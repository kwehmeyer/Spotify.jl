# Library API

```@contents
Pages = ["library.md"]
```

```@docs
Library.library_get_saved_shows()
```


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "library") == true
Private = true
```