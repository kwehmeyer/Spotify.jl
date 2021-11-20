# Run tests on functions in src/by_reference_doc/episodes.jl

@testset verbose = true "GET-request endpoints for episodes" begin

    episode_id = SpEpisodeId()

    @test ~isempty(episodes_get_single(episode_id))

end