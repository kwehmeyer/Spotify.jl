##### Execute this file in the REPL from current Spotify.jl branch directory #####

# Load package environment from "test" folder
using Pkg
Pkg.activate("test")
Pkg.instantiate()
using LocalCoverage

# Switch back to Spotify.jl package environment
Pkg.activate(pwd())
Pkg.instantiate()

# Helper function
error_message(e, stage::String) = @info "Unable to $(stage) coverage data \n Check this error: $(e)"

# Generate coverage summary and html data
try
    generate_coverage("Spotify", genhtml=true, show_summary=true, genxml=false)        
catch e
    error_message(e, "generate")
end

# Open coverage summary in a browser
try
    open_coverage("Spotify")      
catch e
    error_message(e, "open")
end

# Clean up .cov files but keep coverage directory
try
    clean_coverage("Spotify", rm_directory=false)      
catch e
    error_message(e, "clean up")
end





