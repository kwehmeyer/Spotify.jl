using Spotify
using Spotify.Library
if !Spotify.has_ig_access_token()
    Spotify.get_implicit_grant()
    Spotify.wait_for_ig_access()
end
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
