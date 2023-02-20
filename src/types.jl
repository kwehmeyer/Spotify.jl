export SpId, SpCategoryId, SpPlaylistId,  
       SpArtistId, SpShowId, SpEpisodeId, SpTrackId, SpAlbumId
import JSON3.write
using StructTypes
using StructTypes: CustomStruct
import StructTypes: StructType, lower, lowertype
import Base: isempty
"""
All web API arguments are simple strings. Spotify.jl defines
some types that have context-aware representations. Type
names are `Sp____Id`. 

# Examples

Make an instance 
```jula-repl
julia> track_id = SpTrackId()        # output is colored
spotify:track:0WdUHon5tYn2aKve13psfy
```

In simple web API function calls like "audio-analysis" below, the type of the argument is 
obvious from the context; "spotify:track" is superfluous. 

```jula-repl
julia>"audio-analysis/\$track_id"
"audio-analysis/0WdUHon5tYn2aKve13psfy"
```
The actual Julia wrapper function is duck typed, meaning that the 'track_id' argument
type can be both String or SpTrackId. Numbers on the other hand, would produce an error.

```jula-repl
function tracks_get_audio_analysis(track_id)
    tid = SpTrackId(track_id)
    spotify_request("audio-analysis/\$tid")
end
```

Other API calls need more type information. Spotify understands the ['Spotify URI'](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
) format, where type is denoted by string prefixes. Such functions use a 'request body' to pass arguments. Request bodies 
often contain several arguments in a structure, for example a list or a dictionary. Request bodies 
comply with the JSON format.

So in a 'request body', we would represent 'track_id' like this:

```jula-repl
julia> Spotify.JSON3.write(track_id)
"\\"spotify:track:0WdUHon5tYn2aKve13psfy\\""
```


"""
SpPlaylistId, SpTestId, SpTrackId, SpArtistId, SpId, SpAlbumId, SpCategoryId, SpEpisodeId, SpShowId

#### Move everything to keep below here.
abstract type SpType end
StructType(::Type{<:SpType}) = StructTypes.CustomStruct()
lower(x::T) where {T <:SpType} = x.prefix * x.s
#lowertype(x::T) where {T <:SpType} = String
isempty(x::T) where {T <:SpType} = isempty(x.s)

function checked_id_string(ls::String, allowed_prefix)
    s =  startswith(ls, allowed_prefix) ? ls[length(allowed_prefix) + 1 : end] : ls
    if length(s) == 22
        if isid(s)
            s
        else
            error("unrecognized format of base 62 id string: $s")
        end
    else 
        error("id must be length 22, but is $(length(s))")
    end
end
checked_id_string(ls::SpType, allowed_prefix) = checked_id_string(string(ls), allowed_prefix)
# REPL, instead of SpTestId("6rqhFgbbKwnb9MLmUQDhG6")
show(io::IO,  ::MIME"text/plain", x::SpType) =   printstyled(io, x.prefix * x.s ; color = x.displaycolor)
# String interpolation, also `urlstring`, `println`
show(io::IO, x::SpType) =        printstyled(io, x.s; color = x.displaycolor)
# Serialization, as in Spotify.JSON3.write 
#write(x::SpType) =  x.prefix * x.s
#write(io::IO, x::SpType) = write(io, write(x))
#
struct SpTestId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpTestId(ls)
        pref = "spotify:test:"
        new(checked_id_string(ls, pref), pref, 219)
    end
end
SpTestId() = SpTestId("512ojhOuo1ktJprKbVcKyQ")
####
struct SpPlaylistId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpPlaylistId(ls)
        pref = "spotify:playlist:"
        new(checked_id_string(ls, pref), pref, :light_red)
    end
end
SpPlaylistId() = SpPlaylistId("37i9dQZF1E4vUblDJbCkV3")
####
struct SpTrackId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpTrackId(ls)
        pref = "spotify:track:"
        new(checked_id_string(ls, pref), pref, 176)
    end
end
SpTrackId() = SpTrackId("0WdUHon5tYn2aKve13psfy")
####
struct SpArtistId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpArtistId(ls)
        pref = "spotify:artist:"
        new(checked_id_string(ls, pref), pref, :light_magenta)
    end
end
SpArtistId() = SpArtistId("0YC192cP3KPCRWx8zr8MfZ")
####
struct SpId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpId(ls)
        pref = ""
        new(checked_id_string(ls, pref), pref, :cyan)
    end
end
SpId() = SpId("6rqhFgbbKwnb9MLmUQDhG6")
####
struct SpAlbumId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpAlbumId(ls)
        pref = "spotify:album:"
        new(checked_id_string(ls, pref), pref, :light_yellow)
    end
end
SpAlbumId() = SpAlbumId("5XgEM5g3xWEwL4Zr6UjoLo")
####
struct SpCategoryId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpCategoryId(ls)
        pref = "spotify:category:"
        new(checked_id_string(ls, pref), pref, 172)
    end
end
SpCategoryId() = SpCategoryId("0JQ5DAqbMKFAXlCG6QvYQ4")
####
struct SpEpisodeId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpEpisodeId(ls)
        pref = "spotify:episode:"
        new(checked_id_string(ls, pref), pref, :yellow)
    end
end
SpEpisodeId() = SpEpisodeId("512ojhOuo1ktJprKbVcKyQ")
####
struct SpShowId <: SpType
    s::String
    prefix::String
    displaycolor::Union{Symbol, Int}
    function SpShowId(ls)
        pref = "spotify:show:"
        new(checked_id_string(ls, pref), pref, :yellow)
    end
end
SpShowId() = SpShowId("2MAi0BvDc6GTFvKFPXnkCL")



# Verify if the url, id and uri have the correct structure
isid(s::AbstractString) = !isnothing(match(r"\b[a-zA-Z0-9]{22}", s)) && length(s) == 22
# Not currently used, could be nice for parsing returned objects, consider drop.
isurl(s::String) = !isnothing(match(r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)", s))
isuri(s::String) = count(==( ':'), s) == 2 && length(s) - findlast(':', s) == 22
is_string_vector(s::String) = startswith(s, '[') && endswith(s, ']')
is_string_separable(s::String) = (length(split(s, ',')) > 1)
