export SpUri, SpId, SpCategoryId, SpUserId, SpUrl, SpPlaylistId, SpAlbumId
"""
All web API arguments are strings, but types 
`SpUri`, `SpId`, `CategoryId`, `SpUserId`, `SpUrl` 
aids in picking default values. [format](
https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)


PARAMETER  | DESCRIPTION | VALUE 
:----------:| :---------- |:------------:
SpUri       |The resource identifier that you can enter, for example, in the |
            | Spotify Desktop client’s search box to locate an artist,| 
            | album, or track. To find a Spotify URI simply right-|
            | click (on Windows) or Ctrl-Click (on a Mac) on |spotify:track:
            | the artist’s or album’s or track’s name.| 6rqhFgbbKwnb9MLmUQDhG6|
SpId        |The base-62 identifier that you can find at the end of the |
            | Spotify URI (see above) for an artist, track, album, |
            | playlist, etc. Unlike a Spotify URI, a Spotify ID does| 
            | not clearly identify the type of resource; that information is | 
            | provided elsewhere in the call.| 6rqhFgbbKwnb9MLmUQDhG6
SpCategoryId|The unique string identifying the Spotify category.| party|
SpUserId    |The unique string identifying the Spotify user that you can |
            | find at the end of the Spotify URI for the user. The ID | 
            | of the current user can be obtained via the Web API endpoint.| wizzler
SpUrl       |An HTML link that opens a track, album, app, playlist or other |
            | Spotify resource in a Spotify client (which  client |
            | is determined by the user’s device and |  http://open.spotify.com/
            | account settings at play.spotify.com. |   track/6rqhFgbbKwnb9MLmUQDhG6
        
"""
SpUri, SpId, SpCategoryId, SpUserId, SpUrl, SpPlaylistId, SpAlbumId

mutable struct SpUri
    s::String
    SpUri(s) = isuri(s) ? new(s) : error("must be 'spotify:track:<base 62 string>")
end
SpUri() = SpUri("spotify:track:6rqhFgbbKwnb9MLmUQDhG6")

mutable struct SpId
    s::String
    SpId(s) =  isid(s) ? new(s) : error("must be <base 62 string>")
end
SpId() = SpId("6rqhFgbbKwnb9MLmUQDhG6")

mutable struct SpCategoryId
    s::String
end
SpCategoryId() = SpCategoryId("party")

mutable struct SpUserId
    s::String
end
SpUserId() = get_user_name() == "" ? throw(".ini file has no user name") : SpUserId(get_user_name())

mutable struct SpUrl
    s::String
    SpUrl(s) = isurl(s) ? new(s) : error("must be an url")
end
SpUrl() =  SpUrl("http://open.spotify.com/track/6rqhFgbbKwnb9MLmUQDhG6")

mutable struct SpPlaylistId
    s::String
    SpPlaylistId(s) = isid(s) ? new(s) : error("must be <base 62 string> playlist ID")
end
SpPlaylistId() = SpPlaylistId("37i9dQZF1E4vUblDJbCkV3")

mutable struct SpAlbumId
    s::String
    SpAlbumId(s) = isid(s) ? new(s) : error("must be <base 62 string> album ID")
end
SpAlbumId() = SpAlbumId("5XgEM5g3xWEwL4Zr6UjoLo")

# Verify if the url, id and uri have the correct structure
isurl(s) = !isnothing(match(r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)", s))
isid(s) = !isnothing(match(r"\b[a-zA-Z0-9]{22}", s))
isuri(s) = count(==( ':'), s) == 2 && length(s) - findlast(':', s) == 22

# These types should work with string interpolation using $. 
# So we need to alter their undecorated representations.
# For argument inspection, we don't want to hide them not 
# being ordinary strings, so we add color. The color will
# not be used in contexts which can't display color (i.e. 
# when used as an url)
show(io::IO, s::SpUri) =        printstyled(io, s.s; color = :blue)
show(io::IO, s::SpId) =         printstyled(io, s.s; color = 176)
show(io::IO, s::SpCategoryId) = printstyled(io, s.s; color = 172)
show(io::IO, s::SpUrl) =        printstyled(io, s.s; color = :blue, bold = true)
show(io::IO, s::SpUserId) =     printstyled(io, s.s; color = :green)
show(io::IO, s::SpPlaylistId) =     printstyled(io, s.s; color = :light_red)
show(io::IO, s::SpAlbumId) =     printstyled(io, s.s; color = :light_yellow)

# Add quotes "" around the String representation
show(io::IO,  ::MIME"text/plain", s::SpUri) =       printstyled(io, '"' * s.s * '"'; color = :blue)
show(io::IO, ::MIME"text/plain", s::SpId) =         printstyled(io, '"' * s.s * '"'; color = 176)
show(io::IO, ::MIME"text/plain", s::SpCategoryId) = printstyled(io, '"' * s.s * '"'; color = 172)
show(io::IO, ::MIME"text/plain", s::SpUrl) =        printstyled(io, '"' * s.s * '"'; color = :blue, bold = true)
show(io::IO, ::MIME"text/plain", s::SpUserId) =     printstyled(io, '"' * s.s * '"'; color = :green)
show(io::IO, ::MIME"text/plain", s::SpPlaylistId) =     printstyled(io, '"' * s.s * '"'; color = :light_red)
show(io::IO, ::MIME"text/plain", s::SpAlbumId) =     printstyled(io, '"' * s.s * '"'; color = :light_yellow)

show(io::IO, v::Vector{SpUri}) =        show_vector(io, v, "", "")
show(io::IO, v::Vector{SpId}) =         show_vector(io, v, "", "")
show(io::IO, v::Vector{SpCategoryId}) = show_vector(io, v, "", "")
show(io::IO, v::Vector{SpUrl}) =        show_vector(io, v, "", "")
show(io::IO, v::Vector{SpUserId}) =     show_vector(io, v, "", "")
show(io::IO, v::Vector{SpPlaylistId}) = show_vector(io, v, "", "")
show(io::IO, v::Vector{SpAlbumId}) =    show_vector(io, v, "", "")

typeinfo_implicit(::Type{SpUri}) = true
typeinfo_implicit(::Type{SpId}) = true
typeinfo_implicit(::Type{SpCategoryId}) = true
typeinfo_implicit(::Type{SpUrl}) = true
typeinfo_implicit(::Type{SpUserId}) = true
typeinfo_implicit(::Type{SpPlaylistId}) = true
typeinfo_implicit(::Type{SpAlbumId}) = true



