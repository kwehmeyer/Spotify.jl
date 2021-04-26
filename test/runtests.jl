using Test
using Spotify

@testset "Internal format strings" begin
    shortp(x) = repr(x, context = :color=>true)
    longp(x) = repr(:"text/plain", x, context = :color=>true)
    shortp_bw(x) = repr(x)
    longp_bw(x) = repr(:"text/plain", x)

    spuri = SpUri()
    spid = SpId()
    spcategoryid = SpCategoryId()
    spuserid = SpUserId()
    spurl = SpUrl()
    spidvec = [SpId(), SpId()]

    @test shortp(spuri)[1] == '\e'
    @test longp(spuri)[1] == '\e'
    @test shortp_bw(spuri)[1] == 's'
    @test longp_bw(spuri)[1] == '"'

    @test shortp(spid)[1] == '\e'
    @test longp(spid)[1] == '\e'
    @test shortp_bw(spid)[1] == '6'
    @test longp_bw(spid)[1] == '"'

    @test shortp(spcategoryid)[1] == '\e'
    @test longp(spcategoryid)[1] == '\e'
    @test shortp_bw(spcategoryid)[1] == 'p'
    @test longp_bw(spcategoryid)[1] == '"'

    @test shortp(spuserid)[1] == '\e'
    @test longp(spuserid)[1] == '\e'
    @test shortp_bw(spuserid)[1] == 'S'
    @test longp_bw(spuserid)[1] == '"'

    @test shortp(spurl)[1] == '\e'
    @test longp(spurl)[1] == '\e'
    @test shortp_bw(spurl)[1] == 's'
    @test longp_bw(spurl)[1] == '"'

    @test "AA$(spidvec)BB" ==  "AA|6rqhFgbbKwnb9MLmUQDhG6,6rqhFgbbKwnb9MLmUQDhG6|BB"
end

include("generalize_calls.jl")
