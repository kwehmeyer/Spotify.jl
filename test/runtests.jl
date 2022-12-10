using Test, Spotify

#= 
   Test behaviour can be further customized by providing 
   additional arguments to Pkg as shown here:
   Pkg.test("HelloWorld"; test_args = ["foo", "baz"])
=#

# Argument for quiet mode
quiet = length(ARGS) > 0 && ARGS[1] == "q"

errors = false

all_tests = ["test_int_format_strings.jl", 
             "generalize_calls.jl",
             "test_playlists.jl",
             "test_users.jl",
             "test_search.jl",
             "test_markets.jl",
             "test_genres.jl",
             "test_player.jl",
             "test_albums.jl",
             "test_artist.jl",
             "test_tracks.jl",
             "test_shows.jl",
             "test_browse.jl",
             "test_episodes.jl"]

Spotify.refresh_spotify_credentials()             

println("Running full test suite:")

@time for file in all_tests
    println("\nNext: $file")
    try
        include(file)
        println("\t\033[1m\033[32mPASSED\033[0m: $(file)")
    catch e
        println("\t\033[1m\033[31mFAILED\033[0m: $(file)")
        global errors = true

        # Show detailed tracing when not in quiet mode
        if ~quiet
            showerror(stdout, e, backtrace())
            println()
        end
    end
end

if errors
    @warn "Some tests have failed! Check the results summary above."
end