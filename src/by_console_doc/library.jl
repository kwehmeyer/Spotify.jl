"Alias for tracks_get_saved in tracks.jl"
library_get_saved_tracks(;limit = 20, offset = 0, market = "") = tracks_get_saved(;limit, market, offset)


"Alias for show_get_saved in shows.jl"
library_get_saved_shows(;limit = 20, offset = 0) = show_get_saved(;limit, offset)


"Alias for album_get_saved in albums.jl"
library_get_saved_albums(;limit = 20, offset = 0, market = "") = album_get_saved(;limit, offset, market)


"Alias for tracks_get_contains in tracks.jl"
library_check_saved_tracks(track_ids) = tracks_get_contains(track_ids)


"Alias for show_get_contains in shows.jl"
library_check_saved_shows(show_ids) = show_get_contains(show_ids)


"Alias for album_get_contains in albums.jl"
library_check_saved_albums(album_ids) = album_get_contains(album_ids)


#### DELETE ####

"Same as album_remove_from_library in Albums"
function library_remove_albums(album_ids)
    album_remove_from_library(album_ids)
end


"Same as show_remove_from_library"
function library_remove_shows(show_ids)
    show_remove_from_library(show_ids)
end

"Same as tracks_remove_from_library"
function library_remove_tracks(track_ids)
    tracks_remove_from_library(track_ids)
end

#### PUT #####

"Same as tracks_save_library"
function library_save_track(track_ids)
    tracks_save_library(track_ids)
end


"Same as show_save_library"
function library_save_show(show_ids)
    show_save_library(show_ids)
end


"Same as album_save_library"
function library_save_album(album_ids)
    album_save_library(album_ids)
end