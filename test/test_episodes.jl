# Run tests on functions in src/by_reference_doc/episodes.jl

using Spotify.Episodes

@testset verbose = true "GET-request endpoints for episodes" begin

    # Input argument from composite types defined in src/types.jl
    episode_id = SpEpisodeId()

    # Cycle through different input keywords for testing
    markets = ["US", "NL", "DE"]
    offsets = [7, 14]

    @testset "For market = $(market_id)" for market_id in markets

        @test ~isempty(episodes_get_single(episode_id, market = market_id)[1])
        @test ~isempty(episodes_get_multiple("$(episode_id),0Q86acNRm6V9GYx55SXKwf", 
                                              market = market_id)[1])
        @test ~isempty(episodes_get_saved(market = market_id)[1])

    end

    @testset "For offset = $(num_offset)" for num_offset in offsets

        @test ~isempty(episodes_get_saved(offset = num_offset)[1])

    end

    @test ~isempty(episodes_get_contains("$(episode_id),0Q86acNRm6V9GYx55SXKwf")[1])

end