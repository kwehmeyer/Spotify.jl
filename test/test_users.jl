# Run tests on functions in:
# src/by_reference_doc/users.jl
# src/by_reference_doc/follow.jl
using Test, Spotify, Spotify.Users
@testset verbose = true "GET-request endpoints for users" begin
    
    # Input arguments from composite types defined in src/types.jl
    playlist_id = SpPlaylistId()
    user_id = SpUserId()

    # Get current user's profile 
    @test ~isempty(Spotify.users_get_current_profile()[1])
    
    # Get user's top items
    @test ! isempty(users_get_current_user_top_items(type="artists")[1])
    @test ! isempty(users_get_current_user_top_items(type="tracks")[1])

    # Get user's profile
    @test ~isempty(Spotify.users_get_profile(user_id)[1])

    # Get followed artists for current user
    @test ~isempty(Spotify.users_get_follows()[1])

    # Check if current user follows a given artist
    @test ~isempty(Spotify.users_check_current_follows("artist", "7fxBPUc2bTUgl7GLuqjajk")[1])

    # Check if given users follow a given playlist
    @test ~isempty(Spotify.users_check_follows_playlist(playlist_id, user_id)[1])    

end