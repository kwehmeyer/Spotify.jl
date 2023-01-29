# Run tests on functions in src/by_reference_doc/markets.jl
using Test, Spotify, Spotify.Markets
@testset verbose = true "GET-request endpoints for markets" begin

    @test ~isempty(Spotify.markets_get()[1])

end