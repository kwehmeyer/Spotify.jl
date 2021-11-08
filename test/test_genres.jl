# Run tests on functions in src/by_reference_doc/genres.jl

@testset verbose = true "GET-request endpoints for genres" begin

    @test ~isempty(Spotify.genres_get()[1])

end