# Run tests on functions in src/by_reference_doc/shows.jl

using Spotify.Shows

@testset verbose = true "GET-request endpoints for shows" begin

    # Input argument from composite types defined in src/types.jl
    show_id = SpShowId()

    # Cycle through different input keywords for testing
    markets = ["US", "NL", "DE"]
    offsets = [10, 35]

    @testset "For market = $(market_id)" for market_id in markets

        @test ~isempty(show_get_single(show_id, market = "$market_id")[1])

        @test ~isempty(show_get_multiple("$show_id, 4rOoJ6Egrf8K2IrywzwOMk", market = "$market_id")[1])

        @test ~isempty(show_get_episodes(show_id, market = "$market_id")[1])

    end

    @test ~isempty(show_get_saved()[1])

    # Currently shows 403 error, implemented in shows.jl
    @test_broken ~isempty(show_get_contains("2MAi0BvDc6GTFvKFPXnkCL")[1])

end