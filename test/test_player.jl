# Run tests on functions in src/by_reference_doc/player.jl
using Test, Spotify.Player
using Spotify: SpTrackId
@testset verbose = true "GET-request endpoints for player" begin

    #------- Following 3 tests will work only when the Spotify player is playing -------#
    @testset "When Spotify player is playing" begin

        @test ~isempty(player_get_state()[1])

        @test ~isempty(player_get_devices()[1]["devices"])

        @test ~isempty(player_get_current_track()[1])        

    end
    #----------------------------------------------------------------------------------#

    days = [2, 5, 25]

    @testset "For duration = $(day) days" for day in days

        @test ~isempty(player_get_recent_tracks(duration = day)[1])

    end

end

@testset "PUT- and POST request endpoints for player" begin
    #------- Following tests will work only when the Spotify player is playing -------#
    @testset "When Spotify player is playing" begin
        @test isempty(player_pause()[1])
        # Pausing when paused produces an info message
        msg = "403 (code meaning): Forbidden - The server understood the request, but is refusing to fulfill it. \n\t\t(response message): Player command failed: Restriction violated"
        @test_logs (:info, msg) match_mode=:any player_pause()
        @test isempty(player_resume_playback()[1])
        sleep(2)
        @test isempty(player_seek(25000)[1])
        sleep(2)
        @test isempty(player_skip_to_next()[1])
        sleep(2)
        @test isempty(player_skip_to_previous()[1])
        sleep(2)
        uris = SpTrackId.(["4SFBV7SRNG2e2kyL1F6kjU", "1301WleyT98MSxVHPZCA6M"])
        context_uri = SpAlbumId("1XORY4rQNhqkZxTze6Px90")
        uris = SpTrackId.(["4SFBV7SRNG2e2kyL1F6kjU", "46J1vycWdEZPkSbWUdwMZQ"])
        offset = Dict("position" => 1) # Song no.
        position_ms = 82000
        # Play track no. from album from 
        @test isempty(player_resume_playback(;context_uri, offset, position_ms)[1])
        sleep(2)
        offset = Dict("position" => 35) # Song no.
        position_ms = 59000
        # Play track no. from album from a point
        @test isempty(player_resume_playback(;context_uri, offset, position_ms)[1])
        sleep(2)
        position_ms = 82000
        # Play the same two tracks in sequence. The first starting at 82s.
        @test isempty(player_resume_playback(;uris, position_ms)[1])
    end
end