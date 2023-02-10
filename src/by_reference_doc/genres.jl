## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendation-genres
"""
    genres_get()

**Summary**: Retrieve a list of available genres seed parameter values for recommendations.

# Example
```julia-repl
julia> genres_get()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :genres => ["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal",…
```
"""
function genres_get()
    spotify_request("recommendations/available-genre-seeds")
end