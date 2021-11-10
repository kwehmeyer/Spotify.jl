push!(LOAD_PATH,"../src/")
using Documenter, Spotify

makedocs(sitename="Spotify.jl Documentation",
format = Documenter.HTML(prettyurls=false))

deploydocs(
    repo = "github.com/kwehmeyer/Spotify.jl.git",
)
