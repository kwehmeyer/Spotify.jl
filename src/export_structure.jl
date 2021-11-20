# The structure follows https://developer.spotify.com/documentation/web-api/reference/

export Albums, Artists, Browse, Episodes, Follow, Library
export Markets, Personalization, Player, Playlists, Search
export Shows, Tracks, UsersProfile, Objects
@info "Exported Library & etc."
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
    @_ie album_get_single album_get_multiple album_get_tracks album_get_saved album_get_contains
end
baremodule Artists
    import ..@_ie
    @_ie artist_get artist_get_albums artist_top_tracks artist_get_related_artists
end
baremodule Browse
    import ..@_ie
    @_ie category_get_single category_get_multiple  
    @_ie category_get_new_releases   
    @_ie recommendations_get  recommendations_dict_parser
end
baremodule Episodes
    import ..@_ie
    @_ie episodes_get_single episodes_get_multiple episodes_get_saved episodes_get_contains
end
baremodule Follow
    import ..@_ie
    @_ie follow_check follow_check_playlist follow_artists follow_artists_users follow_playlist unfollow_artists_users unfollow_playlist
end
baremodule Library
    import ..@_ie 
    @_ie library_remove_albums library_remove_shows
    @_ie library_remove_tracks library_save_album library_save_show library_save_track
end
baremodule Markets
    import ..@_ie 
    @_ie 
end

baremodule Personalization
    import ..@_ie
    @_ie top_tracks top_artists
end
baremodule Player
    import ..@_ie
    @_ie player_get_state player_get_devices player_get_current_track player_get_recent_tracks
end
baremodule Playlists
    import ..@_ie
    @_ie playlist_get playlist_get_tracks playlist_get_current_user playlist_get_user playlist_get_featured
    @_ie playlist_get_category playlist_get_cover_image
end
baremodule Search
    import ..@_ie
    @_ie search_get
end
baremodule Shows
    import ..@_ie
    @_ie show_get_single show_get_multiple show_get_episodes show_get_saved show_get_contains
end
baremodule Tracks
    import ..@_ie
    @_ie tracks_get_audio_analysis tracks_get_audio_features tracks_get_single tracks_get_multiple
    @_ie tracks_get_saved tracks_get_contains
end
baremodule UsersProfile
    import ..@_ie
    @_ie user_get_profile user_get_current_profile
end
baremodule Objects
    import ..@_ie
    @_ie user_get_current_profile user_get_profile
end
