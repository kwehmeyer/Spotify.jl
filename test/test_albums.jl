# Run tests on functions in src/by_reference_doc/albums.jl

using Spotify.Albums

@testset verbose = true "GET-request endpoints for albums" begin

    # Input argument from composite types defined in src/types.jl
    album_id = SpAlbumId()

    # Cycle through different input keywords for testing
    markets = ["US", "NL", "DE"]
    offsets = [5, 18]

    @testset "For market = $(market_id)" for market_id in markets

        @test ~isempty(album_get(album_id, market = market_id )[1])
        @test ~isempty(album_get_tracks(album_id, market = market_id)[1])

    end

    @testset "For offset = $(num_offset)" for num_offset in offsets

        @test ~isempty(album_get_tracks(album_id, offset = num_offset)[1])

    end

end