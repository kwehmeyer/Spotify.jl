# The structure follows https://developer.spotify.com/documentation/web-api/reference/
# Unique sections from https://developer.spotify.com/console/ are also included.
# Modules are alphabetically sorted.
# Some functions are found in several categories.
#
# The full list of implemented functions was identified using (temporarily installed):
#  using ExportAll
#  @exportAll() (at the end of Spotify module)
#=
    @_ie album_get_contains
    @_ie album_get_multiple
    @_ie album_get_saved
    @_ie album_get_single
    @_ie album_get_tracks
    @_ie artist_get
    @_ie artist_get_albums
    @_ie artist_get_related_artists
    @_ie artist_top_tracks
    @_ie category_get_featured_playlist
    @_ie category_get_multiple
    @_ie category_get_new_releases
    @_ie category_get_playlist
    @_ie category_get_single
    @_ie episodes_get_contains
    @_ie episodes_get_multiple
    @_ie episodes_get_saved
    @_ie episodes_get_single
    @_ie follow_artists
    @_ie follow_artists_users
    @_ie follow_check
    @_ie follow_check_playlist
    @_ie follow_playlist
    @_ie genres_get
    @_ie library_check_saved_albums
    @_ie library_check_saved_shows
    @_ie library_check_saved_tracks
    @_ie library_get_saved_albums
    @_ie library_get_saved_shows
    @_ie library_get_saved_tracks
    @_ie library_remove_albums
    @_ie library_remove_shows
    @_ie library_remove_tracks
    @_ie library_save_album
    @_ie library_save_show
    @_ie library_save_track
    @_ie markets_get
    @_ie player_get_current_track
    @_ie player_get_devices
    @_ie player_get_recent_tracks
    @_ie player_get_state
    @_ie playlist_add_tracks_to_playlist
    @_ie playlist_create_playlist
    @_ie playlist_get
    @_ie playlist_get_category
    @_ie playlist_get_cover_image
    @_ie playlist_get_current_user
    @_ie playlist_get_featured
    @_ie playlist_get_tracks
    @_ie playlist_get_user
    @_ie recommendations_dict_parser
    @_ie recommendations_get
    @_ie search_get
    @_ie show_get_contains
    @_ie show_get_episodes
    @_ie show_get_multiple
    @_ie show_get_saved
    @_ie show_get_single
    @_ie top_artists
    @_ie top_tracks
    @_ie tracks_get_audio_analysis
    @_ie tracks_get_audio_features
    @_ie tracks_get_contains
    @_ie tracks_get_multiple
    @_ie tracks_get_saved
    @_ie tracks_get_single
    @_ie unfollow_artists_users
    @_ie unfollow_playlist
    @_ie users_get_current_profile
    @_ie users_get_current_user_top_items
    @_ie users_get_profile
=#

@info "Exported submodules, which exports all functions. Try `varinfo(Spotify)`, `varinfo(Spotify.Library)`!"
# Export: See below each submodule

"import export shorthand"
macro _ie(foo...)
    expr = :()
    for f in foo
        push!(expr.args, esc(
            quote
                import ..($f)
                export $f
            end))
    end
    expr
end

macro _ie()
    nothing
end
baremodule Albums
    import ..@_ie
    @_ie album_get_contains
    @_ie album_get_multiple
    @_ie album_get_saved
    @_ie album_get_single
    @_ie album_get_tracks
end
export Albums

baremodule Artists
    import ..@_ie
    @_ie artist_get
    @_ie artist_get_albums
    @_ie artist_get_related_artists
    @_ie artist_top_tracks
end
export Artists
baremodule Browse # From 'console'
    import ..@_ie
    @_ie category_get_single 
    @_ie category_get_multiple
    @_ie category_get_new_releases
    @_ie recommendations_get 
    @_ie recommendations_dict_parser
    @_ie category_get_playlist
    @_ie category_get_featured_playlist
end
export Browse
baremodule Categories
    import ..@_ie
    @_ie category_get_featured_playlist
    @_ie category_get_multiple
    @_ie category_get_new_releases
    @_ie category_get_playlist
    @_ie category_get_single
end
export Categories
baremodule Episodes
    import ..@_ie
    @_ie episodes_get_contains
    @_ie episodes_get_multiple
    @_ie episodes_get_saved
    @_ie episodes_get_single
end
export Episodes
baremodule Follow # From 'console'
    import ..@_ie
    @_ie follow_artists
    @_ie follow_artists_users
    @_ie follow_check
    @_ie follow_check_playlist
    @_ie follow_playlist
    @_ie unfollow_artists_users
    @_ie unfollow_playlist
end
export Follow
baremodule Genres
    import ..@_ie
    @_ie genres_get
end
export Genres
baremodule Library # From 'console'
    import ..@_ie
    @_ie library_check_saved_albums
    @_ie library_check_saved_shows
    @_ie library_check_saved_tracks
    @_ie library_get_saved_albums
    @_ie library_get_saved_shows
    @_ie library_get_saved_tracks
    @_ie library_remove_albums
    @_ie library_remove_shows
    @_ie library_remove_tracks
    @_ie library_save_album
    @_ie library_save_show
    @_ie library_save_track
end
export Library
baremodule Markets
    import ..@_ie
    @_ie markets_get
end
export Markets
baremodule Personalization # From 'Console'
    import ..@_ie
    @_ie top_artists
    @_ie top_tracks
end
export Personalization
baremodule Player
    import ..@_ie
    @_ie player_get_current_track
    @_ie player_get_devices
    @_ie player_get_recent_tracks
    @_ie player_get_state
end
export Player
baremodule Playlists
    import ..@_ie
    @_ie playlist_add_tracks_to_playlist
    @_ie playlist_create_playlist
    @_ie playlist_get
    @_ie playlist_get_category
    @_ie playlist_get_cover_image
    @_ie playlist_get_current_user
    @_ie playlist_get_featured
    @_ie playlist_get_tracks
    @_ie playlist_get_user
end
export Search
baremodule Search
    import ..@_ie
    @_ie search_get
end
export Search
baremodule Shows
    import ..@_ie
    @_ie show_get_contains
    @_ie show_get_episodes
    @_ie show_get_multiple
    @_ie show_get_saved
    @_ie show_get_single
end
export Shows
baremodule Tracks
    import ..@_ie
    @_ie tracks_get_audio_analysis
    @_ie tracks_get_audio_features
    @_ie tracks_get_contains
    @_ie tracks_get_multiple
    @_ie tracks_get_saved
    @_ie tracks_get_single
end
export Tracks
baremodule Users
    import ..@_ie
    @_ie users_get_current_profile
    @_ie users_get_current_user_top_items
    @_ie users_get_profile
end
export Users


