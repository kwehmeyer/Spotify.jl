## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-available-markets

"""
    markets_get()

**Summary**: Get the list of markets where Spotify is available.

# Example
```julia-repl
julia> Spotify.markets_get()[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
  :markets => ["AD", "AE", "AG", "AL", "AM", "AO", "AR", "AT", "AU", "AZ"  …
```
"""
function markets_get()

    return Spotify.spotify_request("markets")

end