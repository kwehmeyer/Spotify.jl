# Run tests on functions in src/by_reference_doc/search.jl

@testset verbose = true "GET-request endpoints for search" begin

    @testset "For query = $(query)" for query in ["Coldplay", "Greenday", "Adele"]

        @test ~isempty(Spotify.search_get(;q = "$query", item_type = "album")[1])

    end

    @testset "For item type = $(item_type)" for item_type in ["album", "playlist", "track"]

        @test ~isempty(Spotify.search_get(;q = "Hans Zimmer", item_type = "$item_type")[1])

    end

end

# Test if 400 exception handling works by using an empty search query

@testset "Test 400 Not Found exception" begin

    @test_logs (:info, "Check if the search query is present") match_mode=:any Spotify.search_get(;q = "", item_type = "album")[1]
    
end