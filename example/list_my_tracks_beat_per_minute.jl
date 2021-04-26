using Spotify
using Spotify.Library
using Spotify.Tracks

function listallmine()
    offset = 0
    st, repeat_after_sec = library_get_saved_tracks(2, offset, "NO");
    st
    @info "Listing $(st.total) tracks. Pauses may occur due the the current API rate limit. It may be increased by calling the API with a wider scope."
    offset = 0
    while true
        while true
            repeat_after_sec !=0 && sleep(repeat_after_sec + 0.5)
            st, repeat_after_sec = library_get_saved_tracks(50, offset, "NO")
            repeat_after_sec > 5 && @info "Waiting for $repeat_after_sec s for library API. Scope may affect limits."        
            repeat_after_sec == 0 && break
        end
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
                println(s1, s2, s3)
            end
        end
        offset += length(st.items)
        offset >= st.total && break
    end
end


if !Spotify.has_ig_access_token()
    Spotify.get_implicit_grant()
    Spotify.wait_for_ig_access()
end
listallmine()
