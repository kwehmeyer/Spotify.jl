# Run tests on functions in src/by_reference_doc/search.jl

using Test, Spotify.Search
@testset verbose = true "GET-request endpoints for search" begin

    @testset "For query = $(query)" for query in ["Coldplay", "Greenday", "Adele"]

        @test ~isempty(search_get("$query"; type = "album")[1])

    end

    @testset "For item type = $(type)" for type in ["album", "playlist", "track"]

        @test ~isempty(search_get("Hans Zimmer"; type = "$type")[1])

    end

end

# Test if 400 exception handling works by using an empty search query

@testset "Test 400 Not Found exception handling" begin
    msg = "400 (code meaning): Bad Request - The request could not be understood by the server due to malformed syntax. The message body will contain more information; see Response Schema. \n\t\t(response message): No search query"
    @test_logs (:info, msg) match_mode=:any search_get(""; type = "album")[1]
end