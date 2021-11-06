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
    # Currently show 403 error, implemented in personalization.jl
    # top_tracks(offset=0, limit=20, time_range="medium")
    # top_artists(offset=0, limit=20, time_range="medium")

    # Get user's profile
    @test ~isempty(Spotify.user_get_profile(user_id)[1])

    # Get followed artists for current user
    @test ~isempty(Spotify.follow_artists()[1])

    # Check if current user follows a given artist
    @test ~isempty(Spotify.follow_check("artist", "7fxBPUc2bTUgl7GLuqjajk")[1])

    # Check if given users follow a given playlist
    @test ~isempty(Spotify.follow_check_playlist(playlist_id, user_id)[1])    

end