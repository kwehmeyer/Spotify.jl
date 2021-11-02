# Run tests on playlist_get* functions

@testset "GET-request endpoints for playlists" begin
    
    spplaylistid = SpPlaylistId()

    @test ~isempty(Spotify.playlist_get(spplaylistid.s)[1])

end

