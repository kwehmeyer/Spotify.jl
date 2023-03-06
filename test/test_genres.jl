# Run tests on functions in src/by_reference_doc/genres.jl
using Test, Spotify.Genres
@testset verbose = true "GET-request endpoints for genres" begin

    @test ~isempty(genres_get()[1])

end