# These functions are used in 'mini_player.jl', 'remove_duplates_in_same_playlist' and others.
#  
#  is_item_track_playable                                 (no web API call)
#  track_ids_and_names_in_playlist
#  track_ids_and_names_in_playlist_cleaned_of_duplicates
#  track_ids_and_names_cleaned_of_duplicates                (no web API call)
#  is_track_in_playlist
#  is_track_in_library
#  delete_track_from_library
#  delete_track_from_own_playlist
#  get_owned_playlist_ids_and_names
#  track_album_artists_string
#  playlist_details_string
"""
    is_item_track_playable(it::JSON3.Object) 
        -> Bool

Makes no web API calls.

This set of criteria is not complete. We'd rather include
a non-playable track than exclude it. 

First example, this may deem a track playable, but
explicit content, or that the album is unavailable may decide.

Second example, even though 'available markets' is empty,
a track may actually be playable. So we don't check this field.

"""
function is_item_track_playable(it::JSON3.Object)
    ! haskey(it, :track) && return false
    ! haskey(it.track, :id) && return false
    isnothing(it.track.id) && return false
    haskey(it.track, :is_playable) && ! it.track.is_playable && return false
    true
end


"""
    track_ids_and_names_in_playlist(playlist_id::SpPlaylistId)
        -> (Vector{SpTrackId}, Vector{String})

Currently, Spotify's player shows tracks which have become unavalable as grey. This function
will exclude most of the 'grey' ones, but not all.

If you don't own a playlist, there are additional limits, see `Spotify.Playlists.playlist_get_tracks`.

```julia-repl
julia> playlist_id = SpPlaylistId("2oJVHrxclWP0f9IHE7Bj7a")
spotify:playlist:2oJVHrxclWP0f9IHE7Bj7a

julia> track_ids_names = hcat(track_ids_and_names_in_playlist(playlist_id)...)
7×2 Matrix{Any}:
 spotify:track:6nek1Nin9q48AVZcWs9e9D  "Paradise"
 spotify:track:0Yo9z0PItxg3vXI83HLIFx  "Boli Panieh"
 spotify:track:7LA2VebH12tu9jU0JodX9N  "Banghra Bros"
 spotify:track:5ENZgmiqcT9gdQ4Q9wJoOt  "Calcutta (Taxi, Taxi, Taxi)"
 spotify:track:3YhzLZG5zHPHlteiuv7Ne1  "Ode to the Prostitute"
 spotify:track:2epYMlXJ4ZfexISPrH0urQ  "Ville Hester"
 spotify:track:4bjPx9eLSPcXod7mSzoo5z  "Panj Bindiyaan"
```
"""
function track_ids_and_names_in_playlist(playlist_id::SpPlaylistId)
    fields = "items(track(name,id,is_playable)), next"
    o, waitsec = Spotify.Playlists.playlist_get_tracks(playlist_id; fields, limit = 100);
    track_ids = [SpTrackId(it.track.id) for it in o.items if is_item_track_playable(it)]
    track_names = [string(it.track.name) for it in o.items if is_item_track_playable(it)]
    while o.next !== nothing
        if waitsec > 0
            sleep(waitsec)
        end
        o, waitsec = Spotify.Playlists.playlist_get_tracks(playlist_id; offset = length(track_ids), fields, limit=100);
        append!(track_ids, [SpTrackId(it.track.id) for it in o.items if is_item_track_playable(it)])
        append!(track_names, [string(it.track.name) for it in o.items if is_item_track_playable(it)])
    end
    track_ids, track_names
end


"""
    track_ids_and_names_in_playlist_cleaned_of_duplicates(playlist_id::SpPlaylistId)
        -> (Vector{SpTrackId}, Vector{String})

Reads a playlist's tracks and purges duplicate tracks. The original order is retained. The first copy of 
a track is kept, others are deleted.

Purging is based off unique track-ids. Names are included for checking purposes.
"""
function track_ids_and_names_in_playlist_cleaned_of_duplicates(playlist_id::SpPlaylistId)
    track_ids, track_names = track_ids_and_names_in_playlist(playlist_id)
    track_ids_and_names_cleaned_of_duplicates(track_ids, track_names)
end


"""
    track_ids_and_names_cleaned_of_duplicates(track_ids, track_names)
        -> (Vector{SpTrackId}, Vector{String})

Method makes no web API calls. See `track_ids_and_names_in_playlist_cleaned_of_duplicates`.
"""
function track_ids_and_names_cleaned_of_duplicates(track_ids, track_names)
    # Purging is based off unique track-ids. Names are included for checking purposes.
    # Makes no web API calls
    @assert length(track_ids) == length(track_names)
    # Sorted by names for checking:
    # track_ids_names[sortperm(track_ids_names[:, 2]), :]
    duplrows = _find_duplicate_items(track_ids)
    clean_track_ids = [t for (i, t) in enumerate(track_ids) if i ∉ duplrows] 
    clean_track_names = [n for (i, n) in enumerate(track_names) if i ∉ duplrows]
    clean_track_ids, clean_track_names
end

function _find_duplicate_items(v)
    duplrows = Int[]
    for r in unique(v)
        identicals = findall(t-> t == r, v)
        duplicates = identicals[2:end]
        append!(duplrows, duplicates)
    end
    duplrows
end

"""
    is_track_in_playlist(t::SpTrackId, playlist_id::SpPlaylistId)
        -> Bool
    
"""
function is_track_in_playlist(t::SpTrackId, playlist_id::SpPlaylistId)
    fields = "items(track(name,id)), next"
    o, waitsec = Spotify.Playlists.playlist_get_tracks(playlist_id; fields, limit = 100);
    track_ids = o.items .|> i -> i.track.id |> SpTrackId
    t in track_ids && return true
    while o.next !== nothing
        if waitsec > 0
            sleep(waitsec)
        end
        o, waitsec = Spotify.Playlists.playlist_get_tracks(playlist_id; offset = length(track_ids), fields, limit=100);
        track_ids = o.items .|> i -> i.track.id |> SpTrackId
        t in track_ids && return true
    end
    false
end


"is_track_in_library(track_id::SpTrackId) -> Bool"
is_track_in_library(track_id::SpTrackId) = Spotify.Tracks.tracks_get_contains([track_id])[1][1]


"delete_track_from_library(track_id, playing_now_desc) -> String, prints to stdout"
function delete_track_from_library(track_id, playing_now_desc)
    if is_track_in_library(track_id)
        printstyled(stdout, "Going to delete \" * playing_now_desc * "\" from your library.\n", color = :yellow)
        Spotify.Tracks.tracks_remove_from_library([track_id])
        return ""
    else
        printstyled(stdout, "\n  Can't delete \"" * playing_now_desc * "\"\n  - Not in library.\n", color = :red)
        return "❌"
    end
end


"delete_track_from_own_playlist(track_id, playing_now_desc) -> String, prints to stdout"
function delete_track_from_own_playlist(track_id, playlist_id, playing_now_desc)
    playlist_description = "\"" * playlist_details_string(playlist_id) * " \""
    if ! is_track_in_playlist(track_id, playlist_id)
        printstyled(stdout, "\n  Can't delete \"" * playing_now_desc * "\"\n  - Not in playlist $(playlist_description)\n", color = :red)
       return "❌"
    end
    playlist_details = Spotify.Playlists.playlist_get(playlist_id)[1]
    if isempty(playlist_details)
        printstyled(stdout, "\n  Delete: Can't get playlist details from $(playlist_description).\n", color = :red)
        return "❌"
    end
    plo_id = playlist_details.owner.id
    user_id = Spotify.get_user_name()
    if plo_id !== String(user_id)
        printstyled(stdout, "\n  Can't delete " * playing_now_desc * "\n  - The playlist $(playlist_description) is owned by $plo_id, not $user_id.\n", color = :red)
        return "❌"
    end
    printstyled(stdout, "Going to delete ... $(repr("text/plain", track_id)) from $(playlist_description) \n", color = :yellow)
    res = Spotify.Playlists.playlist_remove_playlist_item(playlist_id, [track_id])[1]
    if isempty(res)
        printstyled(stdout, "\n  Could not delete " * playing_now_desc * "\n  from $(playlist_description). \n  This is due to technical reasons.\n", color = :red)
        return "❌"
    else
        printstyled("The playlist's snapshot ID against which you deleted the track:\n  $(res.snapshot_id)", color = :green)
        return ""
    end
end

"get_owned_playlist_ids_and_names(;silent = false) -> (Vector{SpPlaylistId}, Vector{String}), prints to stdout"
function get_owned_playlist_ids_and_names(;silent = false)
    batchsize = 50
    playlists = Vector{SpPlaylistId}()
    playlistnames = Vector{String}()
    for batchno = 0:200
        offset = batchno * batchsize
        json, waitsec = Spotify.Playlists.playlist_get_current_user(limit = batchsize, offset = batchno * batchsize)
        isempty(json) && break
        waitsec > 0 && throw("Too fast, whoa!")
        l = length(json.items)
        l == 0 && break
        for item in json.items
            if item.owner.display_name == get_user_name()
                ! silent && println(stdout, item.name)
                push!(playlists, SpPlaylistId(item.id))
                push!(playlistnames, item.name)
            else
                ! silent && printstyled(stdout, "We're not including $(item.name), which is owned by $(item.owner.id)\n", color= :176)
            end
        end
    end
    playlists, playlistnames
end


"track_album_artists_string(item::JSON3.Object; link_for_copy = true) -> String"
function track_album_artists_string(item::JSON3.Object; link_for_copy = true)
    a = item.album.name
    ars = item.artists
    vs = [ar.name for ar in ars]
    link = ""
    if link_for_copy
        track_id = SpTrackId(item.id)
        link *= "  " 
        iob = IOBuffer()
        show(IOContext(iob, :color => true), "text/plain", track_id)
        link *= String(take!(iob))
    end
    item.name * " \\ " * a * " \\ " * join(vs, " & ") * link
end


"playlist_details_string(playlist_id::SpPlaylistId; link_for_copy = true) -> String"
function playlist_details_string(playlist_id::SpPlaylistId; link_for_copy = true)
    pld = Spotify.Playlists.playlist_get(playlist_id)[1]
    if isempty(pld)
        return "Can't get playlist details."
    end
    s  = String(pld.name)
    plo_id = pld.owner.id
    user_id = Spotify.get_user_name()
    if plo_id !== String(user_id)
        s *= " (owned by $(plo_id))"
    end
    if pld.description != ""
        s *= "  ($(pld.description))"
    end
    if pld.public && plo_id == String(user_id)
        s *= " (public, $(pld.total) followers)"
    end
    if link_for_copy
        s *= "  " 
        iob = IOBuffer()
        show(IOContext(iob, :color => true), "text/plain", playlist_id)
        s *= String(take!(iob))
    end
    s
end


"playlist_details_string(context::JSON3.Object) -> String"
function playlist_details_string(context::JSON3.Object; link_for_copy = true)
    if context.type !== "playlist"
        s = "Context is not playlist."
        if context.type == "collection"
            s *= " It is library / liked songs."
        end
        return s
    end
    playlist_id = SpPlaylistId(context.uri)
    playlist_details_string(playlist_id; link_for_copy)
end


nothing