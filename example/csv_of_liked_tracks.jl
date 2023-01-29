###
# This script extracts roughly the last 2,000 songs from your "Liked" songs
## It includes all the default track attributes and dates added_at
## YMMV, I'm not sure if I am messing up the indexing, I was never good at 
## counting past 20 anyways, you might see some duplicates which get 
## filtered via the `unique` command on `id`
#
# Run this file from an environent with Spotify, DataFrames and CSV installed!
#
# Hope this helps get you started on using `Spotify.jl`!
#
###

## Libraries
using Spotify
using Spotify.Library
using Spotify.Tracks
using DataFrames


## Get tracks loop
@warn "Attempting to retrieve the last 2,000 liked songs from Spotify \n This may take some time"
tracks_df  = DataFrame()
for batch = 0:20:2000
    println("Getting batch: ", batch/20)
    data, nextwait = library_get_saved_tracks(limit = 20, offset = batch + 1)
    temp = data["items"]

    for i in 1:length(temp)
        temp0 = temp[i]["track"]
        # We ignore 'available markets', since it's a long vector of county codes.
        temp1 = [field for field in temp0 if field[1] !== :available_markets]
        temp2 = DataFrame(temp1)
        temp2[!, :added_at] .= temp[i]["added_at"]
        println("Adding Track: ", temp[i]["track"]["name"])
        append!(tracks_df, temp2, cols = :union)
    end
    length(temp) < 20 && break
    sleep(nextwait)
end

##
size(tracks_df)

unique!(tracks_df, "id")

##
using CSV
something.(tracks_df, missing) |> CSV.write("csv_of_liked_tracks.csv")