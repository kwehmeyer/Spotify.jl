# Examples
## Listing your saved tracks

First things first ensure you have all the required components

```julia
using Spotify
using Spotify.Library
Using Spotify
```

Once you are authenticated you can run 

```julia
offset = 0
st, repeat_after_sec = library_get_saved_tracks(1, offset, "NO")
@info "Listing $(st.total) tracks. Pauses may occur due the the current API rate limit."

repeat_after_sec = 0
while true
    while true
        repeat_after_sec !=0 && sleep(repeat_after_sec + 0.5)
        st, repeat_after_sec = library_get_saved_tracks(50, offset, "NO")
        repeat_after_sec == 0 && break
    end
    for (i, t) in enumerate(st.items)
        println(lpad(i + offset, 5), t.track.name)
    end
    offset += length(st.items)
    offset >= st.total && break
end
```

which may take some time depending on your library size

!!! tip "For faster results"
    We recommend just getting the default number (20) of tracks from your library using `library_get_saved_tracks()`

## Extracting & Saving all your *Liked* songs

Based on indexing using the `library_get_saved_tracks()` function you could potentially create a CSV of all the tracks you've liked.

Here's one example of how you might do this

```julia
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
```

