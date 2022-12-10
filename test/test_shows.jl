# Run tests on functions in src/by_reference_doc/shows.jl

using Test, Spotify.Shows

@testset verbose = true "GET-request endpoints for shows" begin

    # Input argument from composite types defined in src/types.jl
    show_id = SpShowId()
    show_ids = SpShowId.(["5AvwZVawapvyhJUIx71pdJ", "6ups0LMt1G8n81XLlkbsPo"])

    # Cycle through different input keywords for testing
    markets = ["US", "NL", "DE", Spotify.get_user_country()]
    offsets = [10, 35, 0]

    @testset "For market = $(market_id)" for market_id in markets
    
        @test ~isempty(show_get_single(show_id, market = "$market_id")[1])

        @test ~isempty(show_get_multiple(show_ids)[1])

        @test ~isempty(show_get_episodes(show_id, market = "$market_id")[1])

    end

    @test ~isempty(show_get_saved()[1])

    @test ! isempty(show_get_contains("2MAi0BvDc6GTFvKFPXnkCL")[1])

end

@testset verbose = true "PUT and DELETE -request endpoints for shows" begin
    show_ids = SpShowId.(["5AvwZVawapvyhJUIx71pdJ", "6ups0LMt1G8n81XLlkbsPo"])
    @test isempty(show_save_library(show_ids)[1])
    @test isempty(show_remove_from_library(show_ids)[1])
end