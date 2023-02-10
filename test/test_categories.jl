# Run tests on functions in src/by_reference_doc/categories.jl
 
using Test, Spotify.Categories

@testset verbose = true "GET-request endpoints for browse categories" begin
    # Input arguments from composite types defined in src/types.jl
    category_id = SpCategoryId()
    # Cycle through different input keywords for testing
    countries = ["US", "NL", "DE", ""]
    offsets = [14, 42, 0]

    @testset "For country = $(country_id)" for country_id in countries

        @test ~isempty(category_get_single(category_id, country = country_id)[1])

        @testset "For offset = $(num_offset)" for num_offset in offsets

            @test ~isempty(category_get_multiple(country = country_id, offset = num_offset)[1])
            @test ~isempty(category_get_new_releases(country = country_id, offset = num_offset)[1])

        end

    end

end

        

        





