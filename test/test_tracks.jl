# Run tests on functions in src/by_reference_doc/tracks.jl

using Test, Spotify.Tracks

@testset verbose = true "GET-request endpoints for tracks" begin

    track_id = SpId()

    @test ~isempty(tracks_get_audio_analysis(track_id)[1])

    @test ~isempty(tracks_get_audio_features(track_id)[1])

    # Cycle through different input keywords for testing
    markets = ["US", "NL", "DE", ""]

    @testset "For market = $(market_id)" for market_id in markets

        @test ~isempty(tracks_get_single(track_id, market = market_id)[1])
        @test ~isempty(tracks_get_multiple(ids = "4iV5W9uYEdYUVa79Axb7Rh,1301WleyT98MSxVHPZCA6", 
                                                    market = market_id)[1])
        @test ~isempty(tracks_get_saved(market = market_id)[1])

    end

    @test ~isempty(tracks_get_contains("$track_id, 4VqPOruhp5EdPBeR92t6lQ")[1])

    # Create input dicts for recommendation function
    seeds = Dict("seed_artists" => "0YC192cP3KPCRWx8zr8MfZ")
    track_attributes = Dict("max_danceability" => "0.80", "max_energy" => "0.60")

    @test ~isempty(tracks_get_recommendations(seeds; track_attributes)[1])
end