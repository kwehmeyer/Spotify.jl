# Run tests on functions in src/by_reference_doc/playlists.jl

using Test, Spotify.Playlists
using Spotify: SpPlaylistId, SpCategoryId, SpTrackId, get_user_name
using Spotify.Users: users_unfollow_playlist
@testset verbose = true "GET-request endpoints for playlists" begin
    
    # Input arguments from composite types defined in src/types.jl
    playlist_id = SpPlaylistId()
    user_id = get_user_name()
    category_id = SpCategoryId()

    # Cycle through different input keywords for testing
    countries = ["US", "NL", "DE", ""]
    offsets = [10, 35, 0]

    # Start test blocks
    @test ! isempty(playlist_get(playlist_id)[1])

    @test !isempty(playlist_get_current_user(; offset = 0)[1])

    @testset "For offset = $(num_offset)" for num_offset in offsets

        @test ~isempty(playlist_get_tracks(playlist_id; offset = num_offset)[1])
        @test ~isempty(playlist_get_user(user_id; offset = num_offset)[1])

        # Works okay second time
        @test ~isempty(playlist_get_current_user(; offset = num_offset)[1])
    end

    @testset "For country = $(country_id)" for country_id in countries

        @test ~isempty(playlist_get_featured(country = country_id)[1])
        @test ~isempty(playlist_get_category(category_id; country = country_id)[1])

    end

    @test ~isempty(playlist_get_cover_image(playlist_id)[1])

end

# Test if 404 exception handling works by using an incorrect playlist ID

@testset "Test 404 Not Found exception" begin

    @test_logs (:info,  "404 (code meaning): Not Found - The requested resource could not be found. This error can be due to a temporary or permanent condition. \n\t\t(response message): Not found.") match_mode=:any playlist_get_tracks("37i9dQZF1E4vUblDJzzkV3")[1]
    
end

@testset "Create, populate, depopulate, unrefer a private playlist." begin
    description = "Songs about orcs learning to code after being laid off from the mines of Mordor"
    playlist = playlist_create_playlist("Temporary private playlist"; description)[1]
    @test ! isempty(playlist)
    myownplaylistid = playlist.id |> SpPlaylistId
    track_ids = SpTrackId.(["4m6P9J3czb5hiMIuNsWeVO", "619OpJGKpAOrp5rM4Gcs65"])
    snapshot = playlist_add_tracks_to_playlist(myownplaylistid, track_ids)[1]
    @test ! isempty(snapshot)
    snapshot = playlist_remove_playlist_item(myownplaylistid, track_ids)[1]
    @test ! isempty(snapshot)
    noresponse = users_unfollow_playlist(myownplaylistid)[1]
    @test isempty(noresponse)
end