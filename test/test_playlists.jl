# Run tests on functions in src/by_reference_doc/playlists.jl

@testset verbose = true "GET-request endpoints for playlists" begin
    
    # Input arguments from composite types defined in src/types.jl
    playlist_id = SpPlaylistId()
    user_id = SpUserId()
    category_id = SpCategoryId()

    # Cycle through different input keywords for testing
    countries = ["US", "NL", "DE"]
    offsets = [10, 35]

    # Start test blocks
    @test ~isempty(Spotify.playlist_get(playlist_id)[1])

    # Does not run first time
    @test_throws BoundsError ~isempty(Spotify.playlist_get_current_user(; offset = 0)[1])

    @testset "For offset = $(num_offset)" for num_offset in offsets

        @test ~isempty(Spotify.playlist_get_tracks(playlist_id; offset = num_offset)[1])
        @test ~isempty(Spotify.playlist_get_user(user_id; offset = num_offset)[1])

        # Works okay second time
        @test ~isempty(Spotify.playlist_get_current_user(; offset = num_offset)[1])
    end

    @testset "For country = $(country_id)" for country_id in countries

        @test ~isempty(Spotify.playlist_get_featured(country = country_id)[1])
        @test ~isempty(Spotify.playlist_get_category(category_id; country = country_id)[1])

    end

    @test ~isempty(Spotify.playlist_get_cover_image(playlist_id)[1])

end

# Test if 404 exception handling works by using an incorrect playlist ID

@testset "Test 404 Not Found exception" begin

    @test_logs (:info, "404 Not Found - Check if input arguments are okay") match_mode=:any Spotify.playlist_get_tracks("37i9dQZF1E4vUblDJzzkV3")[1]
    
end
