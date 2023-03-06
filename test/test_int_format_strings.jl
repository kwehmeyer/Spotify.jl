using Test
using Spotify: body_string
using Spotify: SpPlaylistId, SpTrackId, SpArtistId, SpAlbumId, SpCategoryId,
    SpEpisodeId, SpShowId, SpId
using Spotify.StructTypes, Spotify.JSON3

@testset "Creation and string representations" begin
    s = "6rqhFgbbKwnb9MLmUQDhG6"
    types = [SpPlaylistId, SpTrackId, SpArtistId, SpId, SpAlbumId, SpCategoryId, 
        SpEpisodeId, SpShowId]
    for typ in types
        instance = typ(s)
        interpolated = "$instance"
        @test interpolated == s
    end
    for typ in types
        instance = typ(s)
        strdisplayed = repr(:"text/plain", instance)
        if typ == SpId
            # The meaning of this ID is given in the context in which it is used.
            @test s == strdisplayed
        else
            strtyp = lowercase(string(Symbol(typ)))[3 : (end -2)]
            @test "spotify:" * strtyp * ":" * s  == strdisplayed
        end
    end
    for typ in types
        st = StructTypes.StructType(typ)
        @test st isa StructTypes.CustomStruct
    end

    for typ in types
        instance = typ(s)
        strjson = JSON3.write(instance)
        if typ == SpId
            strrep = "\"" * s * "\""
        else
            strtyp = lowercase(string(Symbol(typ)))[3 : (end -2)]
            strrep = "\"" * "spotify:" * strtyp * ":" * s * "\"" 
        end
        @test strjson == strrep
        @test strjson == body_string(instance)
    end
    for typ in types
        instance = [typ(s)]
        strjson = JSON3.write(instance)
        if typ == SpId
            strrep = "[\"" * s * "\"]" 
        else
            strtyp = lowercase(string(Symbol(typ)))[3 : (end -2)]
            strrep = "[\"" * "spotify:" * strtyp * ":" * s * "\"]" 
        end
        @test strjson == strrep
        @test strjson == body_string(instance)
    end
    for typ in types
        instance = Dict("id" => typ(s))
        strjson = JSON3.write(instance)
        if typ == SpId
            strrep = "{\"id\":\"" * s * "\"}" 
        else
            strtyp = lowercase(string(Symbol(typ)))[3 : (end -2)]
            strrep = "{\"id\":\"" * "spotify:" * strtyp * ":" * s * "\"}" 
        end
        @test strjson == strrep
        @test strjson == body_string(instance)
    end
    for typ in types
        instance = Dict("id" => typ(s))
        strjson = body_string(;dic = instance)
        if typ == SpId
            stratom = "\"" * s * "\"" 
        else
            strtyp = lowercase(string(Symbol(typ)))[3 : (end -2)]
            stratom = "\"" * "spotify:" * strtyp * ":" * s * "\"" 
        end
        strrep = "{\"dic\":{\"id\":" * stratom * "}}"
        @test  strjson == strrep
    end
end

@testset "Drop zero-value arguments" begin
    context_uri = [SpAlbumId()]
    cs = context_uri[1].s
    crepr = "{\"context_uri\":[\"spotify:album:$cs\"]}"
    @test body_string(;context_uri) == crepr
    uris = [SpTrackId()]
    us =  uris[1].s
    urepr = "{\"uris\":[\"spotify:track:$us\"]}"
    @test body_string(;uris) == urepr
    pop!(context_uri)
    @test body_string(;context_uri) == ""
    @test body_string(;context_uri, uris) == urepr
    @test body_string(;uris, context_uri) == urepr
    context_uri = SpAlbumId("4b3t4n2VPy3swNN3STuUTc")
    uris = SpTrackId.(["4SFBV7SRNG2e2kyL1F6kjU", "46J1vycWdEZPkSbWUdwMZQ"])
    offset_ms = 82000
    @test body_string(;uris, context_uri, offset_ms) == "{\"uris\":[\"spotify:track:4SFBV7SRNG2e2kyL1F6kjU\",\"spotify:track:46J1vycWdEZPkSbWUdwMZQ\"],\"context_uri\":\"spotify:album:4b3t4n2VPy3swNN3STuUTc\",\"offset_ms\":82000}"
end
