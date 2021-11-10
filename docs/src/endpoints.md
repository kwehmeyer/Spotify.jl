# Endpoints 

Here we list out all the endpoints for given portions of the API

!!! warning "Permissions"
    Certain endpoints require special permissions that would need elevated authentication methods

```@contents
Pages = ["endpoints.md"]
```

## Albums

Album endpoints are somewhat limited but can be combined with other calls to become very powerful

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "album") == true
Private = true
```
## Artist


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "artist") == true
Private = true
```

## Browse


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "category") == true
Private = true
```

## Episodes 

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "episodes") == true
Private = true
```
## Follow

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "follow") == true
Private = true
```

## Genres    

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "genres") == true
Private = true
```

## Library
Endpoints referenced [here](https://developer.spotify.com/console/library/) are included in the library section.
These functions act on whoever has authorized their account to be queried. They can answer questions like

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "library") == true
Private = true
```

## Markets

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "markets") == true
Private = true
```

## Personlization


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "top") == true
Private = true
```

## Playlists


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "playlist") == true
Private = true
```

## Search

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "search") == true
Private = true
```

## Shows

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "show") == true
Private = true
```
## Tracks


```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "tracks") == true
Private = true
```
## Users

```@autodocs
Modules = [Spotify]
Order = [:function]
Filter = t -> contains(String(Symbol(t)), "user") == true
Private = true
```

