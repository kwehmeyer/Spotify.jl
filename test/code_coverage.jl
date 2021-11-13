# Execute this file in the REPL to generate code coverage metrics for current branch

# Print in color
function print_rgb(r, g, b, t)
    print("\e[1m\e[38;2;$r;$g;$b;249m",t)
end

# Generate .cov files by running the test suite

# WARNING: Tests in test_player.jl will pass only when the Spotify player is actively playing something
using Pkg
Pkg.test("Spotify"; coverage=true)

# Process .cov files in Spotify.jl folder using Coverage.jl
# Note that Coverage.jl is added to test folder Project.toml, and will therefore be only
# used when running this file
using Coverage
coverage = process_folder(pwd())

# Get total coverage for all Julia files
covered_lines, total_lines = get_summary(coverage)
code_cov_percent = round((covered_lines / total_lines) * 100, digits = 2)

print_rgb(102, 255, 102, "Code coverage in this branch is $(code_cov_percent) % \n")

# Time to glance at the result
sleep(5)

# Export LCOV
filename = "lcov.info"
if isfile(filename)
    rm(filename)
end
LCOV.writefile(filename, coverage)

# Clean up .cov files
clean_folder(pwd())