# OBSOLETE, these are keys in a dictionary, automatically made in src/utils/utilities.jl
[
#= 1-2 Albums 2 functions =#
:album_get,  :album_get_tracks,
#= 3-6 Artists 4 functions =#
:artist_get,  :artist_get_albums,  :artist_top_tracks,  :artist_get_related_artists,
#= 8-13 Browse 7 functions =#
:category_get,  :category_get_playlist,  :category_get_several,  :category_get_new_releases, 
:category_get_featured_playlist, :recommendations_get,  :recommendations_dict_parser,
#= 14 Episodes 1 method =#
:episodes_get,
#= 15-21 Follow 7 functions =#
:follow_check,  :follow_check_playlist,  :follow_artists,  :follow_artists_users,  :follow_playlist, 
:unfollow_artists_users,  :unfollow_playlist,
#= 22-33 Library 12 functions =#
:library_get_saved_tracks,  :library_get_saved_shows,  :library_get_saved_albums, 
:library_check_saved_tracks, :library_check_saved_shows,  :library_check_saved_albums, 
:library_remove_albums,  :library_remove_shows, :library_remove_tracks,  :library_save_album,  
:library_save_show,  :library_save_track,
#= 34-35 Personalization 2 functions =#
:top_tracks,  :top_artists,
#= Player =#
#= Playlists =#
#= Search =#
#= 36-37 Shows 2 functions =#
:show_get,  :show_get_episodes,
#= 38-40 Tracks 3 functions =#
:tracks_get_audio_analysis, :tracks_get_audio_features, :tracks_get
#= UsersProfile =#
#= Objects =#
]