# Run tests on functions in:
# src/by_reference_doc/users.jl
# src/by_reference_doc/follow.jl
# src/by_reference_doc/personalization.jl

@testset verbose = true "GET-request endpoints for users" begin
    
    # Input arguments from composite types defined in src/types.jl
    playlist_id = SpPlaylistId()
    user_id = SpUserId()

    # Get current user's profile 
    @test ~isempty(Spotify.user_get_current_profile()[1])
    
    # Get user's top items
    # Currently shows 403 error, implemented in personalization.jl
    # @test_skip will not execute the test but report it as "Broken"
    @test_skip ~isempty(Spotify.top_tracks()[1])
    @test_skip ~isempty(Spotify.top_artists()[1])

    # Get user's profile
    @test ~isempty(Spotify.user_get_profile(user_id)[1])

    # Get followed artists for current user
    @test ~isempty(Spotify.follow_artists()[1])

    # Check if current user follows a given artist
    @test ~isempty(Spotify.follow_check("artist", "7fxBPUc2bTUgl7GLuqjajk")[1])

    # Check if given users follow a given playlist
    @test ~isempty(Spotify.follow_check_playlist(playlist_id, user_id)[1])    

end