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
             "test_episodes.jl"]
   

println("Running full test suite. NOTE: Have an active and playing player running on some device.")
# Suppress problem-less requests. In case of http 'errors', relevant info is printed 
# in red.
LOGSTATE.authorization=false;LOGSTATE.request_string=false;LOGSTATE.empty_response=false

using Spotify: LOGSTATE

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