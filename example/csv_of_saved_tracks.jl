###
# This script extracts roughly the last 2,000 songs from your "Liked" songs
## It includes all the default track attributes and dates added_at
## YMMV, I'm not sure if I am messing up the indexing, I was never good at counting past 20 anyways, you might see some duplicates which get 
## filtered via the `unique` command on `id`
#
# Hope this helps get you started on using `Spotify.jl`!
###

## Libraries
using Spotify
using Spotify.Library
using Spotify.Tracks
using DataFrames


## Get tracks loop

function define_df()
    @info Defining the dataframe
    temp = library_get_saved_tracks(1)[1]["items"][1]
    global tracks_df = DataFrame(;Dict(temp["track"])...)
    tracks_df["added_at"] = temp["added_at"]
    delete!(tracks_df,1)
end

define_df()
##

@warn "Attempting to retrieve the last 2,000 songs from Spotify \n This may take some time"
for batch = 0:20:2000
    println("Getting batch: ", batch/20)
    temp = library_get_saved_tracks(20,(batch+1))[1]["items"]
    #temp_df = DataFrame(;Dict(temp["track"])...)
    #temp_df["added_at"] = temp["added_at"]

    for i in 1:20
        temp2 = DataFrame(;Dict(temp[i]["track"])...)
        temp2["added_at"] = temp[i]["added_at"]
        println("Adding Track: ", temp[i]["track"]["name"])
        append!(tracks_df, temp2, cols=:union)

    end

    #sleep(rand(1:11))
end

##
size(tracks_df)

unique!(tracks_df, "id")

##
using CSV
something.(tracks_df, missing) |> CSV.write("track_data.csv")