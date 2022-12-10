# Run tests on functions in:
# src/by_reference_doc/users.jl
using Test, Spotify.Users
@testset verbose = true "GET-request endpoints for users" begin
    
    # Input arguments from composite types defined in src/types.jl
    playlist_id = SpPlaylistId()
    user_id = get_user_name()

    # Get current user's profile 
    @test ~isempty(users_get_current_profile()[1])
    
    # Get user's top items
    @test ! isempty(users_get_current_user_top_items(type="artists")[1])
    @test ! isempty(users_get_current_user_top_items(type="tracks")[1])

    # Get user's profile
    @test ~isempty(users_get_profile(user_id)[1])

    # Get followed artists for current user
    @test ~isempty(users_get_follows()[1])

    # Check if current user follows a given artist
    @test ~isempty(users_check_current_follows(["7fxBPUc2bTUgl7GLuqjajk"])[1])

    # Check if current user follows a given user
    @test ~isempty(users_check_current_follows("smedjan"; item_type = "user")[1])

    @test ~isempty(users_check_current_follows("7fxBPUc2bTUgl7GLuqjajk")[1])
    # Check if given users follow a given playlist
    @test ~isempty(users_check_follows_playlist(playlist_id, user_id)[1])    

end

@testset verbose = true "PUT- and DELETE request endpoints for users" begin
    playlist_id = SpPlaylistId("37i9dQZF1DX1rVvRgjX59F")
    @test isempty(users_unfollow_playlist(playlist_id)[1])
    @test isempty(users_follow_playlist(playlist_id)[1])

    artist_ids = SpArtistId.(["2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6"])
    @test isempty(users_follow_artists_users(artist_ids)[1])
    @test isempty(users_unfollow_artists_users(artist_ids)[1])
end