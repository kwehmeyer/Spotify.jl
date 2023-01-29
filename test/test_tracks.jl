# Run tests on functions in src/by_reference_doc/tracks.jl

using Spotify.Tracks

@testset verbose = true "GET-request endpoints for tracks" begin

    track_id = SpId()

    @test ~isempty(tracks_get_audio_analysis(track_id)[1])

    @test ~isempty(tracks_get_audio_features(track_id)[1])

    # Cycle through different input keywords for testing
    markets = ["US", "NL", "DE"]

    @testset "For market = $(market_id)" for market_id in markets

        @test ~isempty(tracks_get_single(track_id, market = market_id)[1])
        @test ~isempty(tracks_get_multiple(ids = "4iV5W9uYEdYUVa79Axb7Rh,1301WleyT98MSxVHPZCA6", 
                                                    market = market_id)[1])
        @test ~isempty(tracks_get_saved(market = market_id)[1])

    end

    @test ~isempty(tracks_get_contains("$track_id, 4VqPOruhp5EdPBeR92t6lQ")[1])

end