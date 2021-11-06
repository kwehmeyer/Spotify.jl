# Run tests on functions in src/by_reference_doc/search.jl

@testset verbose = true "GET-request endpoints for search" begin

    for query in ["Coldplay", "Greenday", "Adele"]

        @test ~isempty(Spotify.search_get(;q = "$query", item_type = "album")[1])

    end

end