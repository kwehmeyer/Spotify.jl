###########################################
# 'Liked' / 'Songs' / 'Save' / 'My tracks'
#  has changed role several times. 
#
# It now works like playlist that has some role in picking
# recommendations, as in 'Discover weekly'. Hence, the 
# now missing 'dislike' functionality can be replaced 
# by 'remove from liked songs'. 
#
# Currently, only Premium subscribers can 
# download tracks from whole playlists and albums, which
# is now a separate feature. 
#
# This "playlist" can be read with scope 
# 'user-library-read';
# 'playlist-read-private' is not required.
###########################################


using Spotify
using Spotify.Library
using Spotify.Tracks
function list_liked(io = stdout)
    # Throwaway warmup. This gets us the scopes we need. And if user is slow to
    # engage with the browser, this first call might be bothched anyway.
    # Even if user consciously refuses the addidtional scope we ask for, this could
    # work anyway, although perhaps with more waiting.
    st, repeat_after_sec = library_get_saved_tracks(limit = 2);
    @info "Listing $(st.total) tracks. Pauses may occur due the the current API rate limit. It may be increased by calling the API with a wider scope."
    offset = 0
    while true
        repeat_after_sec !=0 && sleep(repeat_after_sec + 0.5)
        st, repeat_after_sec = library_get_saved_tracks(;limit = 50, offset)
        repeat_after_sec > 5 && @info "Waiting for $repeat_after_sec s for library API."        
        sleep(repeat_after_sec + 0.5)
        if length(st) != 0
            for (i, t) in enumerate(get(st, :items, []))
                tr = t.track
                s1 = lpad(i + offset, 5)
                s2 = lpad(tr.name, 100)
                id = tr.id
                te = 0
                af = Spotify.JSON3.Object()
                if Spotify.isid(id)
                    while true
                        repeat_after_sec !=0 && sleep(repeat_after_sec + 0.5)
                        af, repeat_after_sec =  tracks_get_audio_features(id)
                        if !(typeof(af)  <: Spotify.JSON3.Object)
                            @warn typeof(af)
                        end
                        repeat_after_sec > 5 && @info "\n Waiting for $repeat_after_sec s for tracks API. Scope may affect limits."
                        repeat_after_sec == 0 && break
                    end
                    te = round(Int64, get(af, :tempo, 0))
                end
                s3 = lpad(te, 4)
                println(io, s1, s2, s3)
            end
        end
        print(stdout, "$offset/$(st.total)  ")
        offset += length(st.items)
        offset >= st.total && break
    end
    println()
end

open("list_liked.csv", "w") do io
   list_liked(io)
end
