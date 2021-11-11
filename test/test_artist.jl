# Run tests on functions in src/by_reference_doc/artist.jl

@testset verbose = true "GET-request endpoints for artists" begin
    
    # Input arguments from composite types defined in src/types.jl
    artist_id = SpArtistId()

    # Cycle through different input keywords for testing
    countries = ["US", "NL", "DE"]
    offsets = [25, 42]

    @test ~isempty(Spotify.artist_get(artist_id)[1])

    @testset "For country = $(country_id)" for country_id in countries

        @testset "For offset = $(num_offset)" for num_offset in offsets

            @test ~isempty(Spotify.artist_get_albums(artist_id, country = country_id, offset = num_offset)[1])            

        end

        @test ~isempty(Spotify.artist_top_tracks(artist_id, country = country_id)[1])

    end

    @test ~isempty(Spotify.artist_get_related_artists(artist_id)[1])

end