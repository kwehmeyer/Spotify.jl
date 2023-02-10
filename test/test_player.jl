# Run tests on functions in src/by_reference_doc/player.jl
using Test, Spotify.Player
@testset verbose = true "GET-request endpoints for player" begin

    #------- Following 3 tests will work only when the Spotify player is active -------#
    @testset "When Spotify player is active" begin

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