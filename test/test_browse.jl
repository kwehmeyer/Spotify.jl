# Run tests on functions in src/by_reference_doc/browse.jl

using Spotify.Browse

@testset verbose = true "GET-request endpoints for browse categories" begin

    # Input arguments from composite types defined in src/types.jl
    category_id = SpCategoryId()

    # Cycle through different input keywords for testing
    countries = ["US", "NL", "DE"]
    offsets = [14, 42]

    @testset "For country = $(country_id)" for country_id in countries

        @test ~isempty(category_get_single(category_id, country = country_id)[1])

        @testset "For offset = $(num_offset)" for num_offset in offsets

            @test ~isempty(category_get_multiple(country = country_id, offset = num_offset)[1])
            @test ~isempty(category_get_new_releases(country = country_id, offset = num_offset)[1])

        end

    end

    # Create input dicts for recommendation function
    seeds = Dict("seed_artists" => "0YC192cP3KPCRWx8zr8MfZ")
    track_attributes = Dict("max_danceability" => "0.80", "max_energy" => "0.60")

    @test ~isempty(recommendations_get(seeds, track_attributes = track_attributes)[1])

end



        

        





