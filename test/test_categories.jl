# Run tests on functions in src/by_reference_doc/categories.jl
 
using Test, Spotify.Categories

@testset verbose = true "GET-request endpoints for browse categories" begin
    # Input arguments from composite types defined in src/types.jl
    category_id = SpCategoryId()
    # Cycle through different input keywords for testing
    countries = ["US", "NL", "DE", ""]
    offsets = [0, 10]
    category_ids = SpCategoryId[]
    category_names = String[]
    for country_id in countries
        categories_object = category_get_multiple(country = country_id, limit=50)[1].categories
        for catobj in categories_object.items
            nam = catobj.name
            id = catobj.id
            if length(id) == 22
                push!(category_ids, SpCategoryId(id))
                push!(category_names, nam)
            else
                println("Unexpected category format. country = $country_id, name = $nam, id = $id")
            end
        end
    end
    # Some names refer to the same id, but in different languages.
    @test length(Set(category_names)) > length(Set(category_ids))

    @test category_get_single("party", locale = "es_MX")[1].name == "Fiesta"

    @testset "For country = $(country_id)" 
        @testset "For offset = $(num_offset)" for num_offset in offsets
            @test ~isempty()
            @test ~isempty(category_get_new_releases(country = country_id, offset = num_offset)[1])
            @test ~isempty(category_get_playlist(country = country_id, offset = num_offset)[1])
            @test ~isempty(category_get_feautured_playlist(country = country_id, offset = num_offset)[1]) 
        end
    end
end
        

        





