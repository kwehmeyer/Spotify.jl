# OBSOLETE?
#= 
Test every function once in sequence.
Sequence could matter ?
=#
#using Test
using Spotify
using Albums, Artists, Browse, Episodes, Follow, Library
using Markets, Player, Playlists, Search
using  Shows, Tracks, UsersProfile, Objects

#= Albums =#
album_get(album_id, market = "")
album_get_tracks(album_id, limit = 20, offset = 0, market = "")

#= Artists =#
artist_get(artist_id)
artist_get_albums(artist_id, include_groups = "None", country = "US", limit = 20, offset = 0)
artist_top_tracks(artist_id, country = "US")
artist_get_related_artists(artist_id)

#= Browse =#
category_get(category_id, country = "US", locale = "en")
category_get_playlist(category_id, country = "US", limit = 20, offset = 0)
category_get_several(country = "US", locale = "en", limit = 20, offset = 0)
category_get_new_releases(country = "US", locale = "en", limit = 20, offset = 0)
category_get_featured_playlist(country = "US", locale = "en", limit = 50, offset = 0, timestamp = string(now())[1:19])
recommendations_get(
    seeds,
    track_attributes,
    limit = 50,
    market = "US"
)
recommendations_dict_parser(track_attributes::Dict)

#= Episodes =#
episodes_get(episode_id, market = "")

#= Follow =#
users_check_current_follows(type, ids)
users_check_follows_playlist(playlist_id, ids)
users_get_follows(type = "artist", limit = 20)
follow_artists_users(type, ids)
users_follow_playlist(playlist_id)
users_unfollow_artists_users(type, ids)
users_unfollow_playlist(playlist_id)

#= Library =#
library_get_saved_tracks(limit = 20, offset = 0, market = "")
library_get_saved_shows(limit = 20, offset = 0)
library_get_saved_albums(limit = 20, offset = 0, market = "")
library_check_saved_tracks(track_ids)
library_check_saved_shows(show_ids)
library_check_saved_albums(album_ids)
library_remove_albums(album_ids)
library_remove_shows(show_ids)
library_remove_tracks(track_ids)
library_save_album(album_ids)
library_save_show(shows_ids)
library_save_track(track_ids)

#= Personalization =#
top_tracks(offset = 0, limit = 20, time_range = "medium")
top_artists(offset = 0, limit = 20, time_range = "medium")

#= Player =#
show_get(show_id, market = "")
show_get_episodes(show_id, market = "", limit = 20, offset = 0)

#= Playlists =#
tracks_get_audio_analysis(track_id)
tracks_get_audio_features(track_id)
tracks_get(track_id, market = "")

#= Search =#
#= Shows =#
#= Tracks =#
#= UsersProfile =#
#= Objects =#
