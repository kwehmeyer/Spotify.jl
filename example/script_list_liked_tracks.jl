using Spotify
using Spotify.Library
include("playlist_and_library_utilties.jl")
# Get one track.
st, repeat_after_sec = library_get_saved_tracks(;limit = 1)
@info "Listing $(st.total) saved / liked tracks. Pauses may occur due the the current API rate limit."

repeat_after_sec, offset = 0, 0
while true
    global repeat_after_sec, offset, st
    while true
        global repeat_after_sec, offset
        repeat_after_sec !=0 && sleep(repeat_after_sec + 0.5)
        global st, repeat_after_sec = library_get_saved_tracks(; offset)
        repeat_after_sec == 0 && break
        @info "Waiting for api limiter for $repeat_after_sec seconds"
    end
    for (i, t) in enumerate(st.items)
        print(lpad(i + offset, 5), " ")
        println(track_album_artists_string(t.track))
    end
    println("----------")
    offset += length(st.items)
    offset >= st.total && break
end
