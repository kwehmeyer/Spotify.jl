"""
    parse_copied_link(s)
    -> SpPlaylistId, SpTrackId, SpArtistId, SpId, SpAlbumId, SpCategoryId, SpEpisodeId, SpShowId

Parse links copied from Spotify to a type which can be used in API wrapper calls:

Spotify app -> Right click -> Share -> Copy link to clipboard

Spotify app -> Right click -> Share -> Copy embed code to clipboard

```julia-repl
julia> track_id = parse_copied_link(\"https://open.spotify.com/track/0pXkRXjPFg0NCLgPTyJKwc?si=6e74b17f726244d7\")
spotify:track:0pXkRXjPFg0NCLgPTyJKwc

julia> artist_id = parse_copied_link("<iframe style=\"border-radius:12px\" src=\"https://open.spotify.com/embed/artist/7FpOGzPK8QgIpFOky6PnGk?utm_source=generator\" width=\"100%\" height=\"352\" frameBorder=\"0\" allowfullscreen=\"\" allow=\"autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture\" loading=\"lazy\"></iframe>"
```
"""
function parse_copied_link(s)
    m = match(r"\b[a-zA-Z0-9]{22}", s)
    id = m.match
    pref = s[1:m.offset - 1]
    contains(pref, "track") && return SpTrackId(id)
    contains(pref, "playlist") && return SpPlaylistId(id)
    contains(pref, "artist") && return SpArtistId(id)
    contains(pref, "album") && return SpAlbumId(id)
    contains(pref, "category") && return SpCategoryId(id)
    contains(pref, "episode") && return SpEpisodeId(id)
    contains(pref, "show") && return SpShowId(id)
    SpId(id)
end