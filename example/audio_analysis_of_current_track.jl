using Spotify, Spotify.Player, Spotify.Tracks
# Note, we don't change LOGSTATE and get lots of output.
json = player_get_state()[1]
@assert json != JSON3.Object() "None playing (on any device)"
it = json.item
trackid = SpId(it.id)
af = tracks_get_audio_features(trackid)[1]
begin
    printstyled(rpad("Currently playing: ", 20), color=:light_black)
    printstyled(rpad(it.name, 80), color=:green)
    for ar in it.artists
        printstyled(rpad(ar.name, 40), color=:blue)
    end
    print("\n")
end


iaf = Dict([f for f in af if f[1] ∉ [:type, :id, :uri, :track_href, :analysis_url, :duration_ms]])
hs = keys(iaf) .|> string
ws = length.(hs) .+ 3
vs = values(iaf) .|> string
for (h, w) in zip(hs, ws)
    print(rpad(h, w))
end
print("\n")
for (v, w) in zip(vs, ws)
    print(rpad(v, w))
end
print("\n")

