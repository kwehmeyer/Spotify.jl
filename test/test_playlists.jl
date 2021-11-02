# Run tests on functions in src/by_reference_doc/playlists.jl

@testset "GET-request endpoints for playlists" begin
    
    playlist_id = SpPlaylistId()
    user_id = SpUserId()
    category_id = SpCategoryId()

    @test ~isempty(Spotify.playlist_get(playlist_id)[1])

    @test ~isempty(Spotify.playlist_get_tracks(playlist_id)[1])

    @test ~isempty(Spotify.playlist_get_user(user_id)[1])

    @test ~isempty(Spotify.playlist_get_featured())

    @test ~isempty(Spotify.playlist_get_category(category_id)[1])

    @test ~isempty(Spotify.playlist_get_cover_image(playlist_id)[1])

end

