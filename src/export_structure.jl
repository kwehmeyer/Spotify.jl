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
    @_ie album_get album_get_tracks
end
baremodule Artists
    import ..@_ie
    @_ie artist_get artist_get_albums artist_top_tracks artist_get_related_artists
end
baremodule Browse
    import ..@_ie
    @_ie category_get    category_get_playlist    category_get_several   
    @_ie category_get_new_releases    category_get_featured_playlist  
    @_ie recommendations_get  recommendations_dict_parser
    # single parameter validation - integer or float
    @_ie min_acousticness  min_danceability  min_duration_ms  min_energy  min_instrumentalness
    @_ie min_key  min_liveness  min_loudness  min_mode  min_popularity  min_speechiness  
    @_ie min_tempo  min_time_signature  min_valence  max_acousticness  max_danceability  
    @_ie max_duration_ms  max_energy  max_instrumentalness  max_key  max_liveness 
    @_ie max_loudness  max_mode  max_popularity  max_speechiness  max_tempo  
    @_ie max_time_signature  max_valence  target_acousticness  target_danceability  
    @_ie target_duration_ms  target_energy  target_instrumentalness  target_key  
    @_ie target_liveness  target_loudness  target_mode  target_popularity  
    @_ie target_speechiness  target_tempo  target_time_signature  target_valence  
end
baremodule Episodes
    import ..@_ie
    @_ie episodes_get 
end
baremodule Follow
    import ..@_ie
    @_ie follow_check follow_check_playlist follow_artists follow_artists_users follow_playlist unfollow_artists_users unfollow_playlist
end
baremodule Library
    import ..@_ie 
    @_ie library_get_saved_tracks library_get_saved_shows library_get_saved_albums library_check_saved_tracks
    @_ie library_check_saved_shows library_check_saved_albums library_remove_albums library_remove_shows
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
end
baremodule Playlists
    import ..@_ie
end
baremodule Search
    import ..@_ie
    @_ie 
end
baremodule Shows
    import ..@_ie
    @_ie show_get show_get_episodes
end
baremodule Tracks
    import ..@_ie
    @_ie tracks_get_audio_analysis tracks_get_audio_features tracks_get
end
baremodule UsersProfile
    import ..@_ie
    @_ie 
end
baremodule Objects
    import ..@_ie
    @_ie 
end
