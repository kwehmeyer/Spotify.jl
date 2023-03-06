# Mini-player
#
# Use case 1: You want to impress coworkers by staying in
#             the command line interface all day. The player
#             is a REPL mode, which is considered cool.
#
# Use case 2:  You're training with sweaty hands and want keypress
#              operation of music;  magic mouse and touch screen cell
#              phone is inoperable. 

using Spotify, Spotify.Player, Spotify.Playlists, Spotify.Tracks
using Base: text_colors
using REPL
using REPL.LineEdit
import Spotify.JSON3

"""
    get_player_state_print_feedback()
    --> state object
Note: state contains the current track,
but it takes up to a second to update after changes.
"""
function get_player_state_print_feedback()
    st = player_get_state()[1]
    if isempty(st)
        print(stdout, """Can't get Spotify state.
        - Is $(Spotify.get_user_name()) running Spotify on any device? 
        - Has $(Spotify.get_user_name()) started playing any track?
        """)
    end
    st
end

"""
    current_playing_string()
    -> String

Please wait 1 second after changes for correct info.
"""
function current_playing_string(; link_for_copy = true)
    # Ref. delay https://github.com/spotify/web-api/issues/821#issuecomment-381423071
    st = get_player_state_print_feedback()
    isempty(st) && return ""
    track_album_artists_string(st.item; link_for_copy)
end


# Functions included
include("playlist_and_library_utilties.jl")


"""
    current_playlist_context_string()
    -> String

Please wait 1 second after changes for correct info.
"""
function current_playlist_context_string()
    st = get_player_state_print_feedback()
    isempty(st) && return ""
    isnothing(st.context) && return "No current context"
    s = playlist_details_string(st.context)
    # Also check if we have played past the end of the playlist and continued into the 'recommendations'
    track_id = SpTrackId(st.item.uri)
    if st.context.type == "collection"
        if ! is_track_in_library(track_id)
            s *= " Past end, in 'recommendations'"
        end
    elseif st.context.type == "playlist"
        playlist_id = SpPlaylistId(st.context.uri)
        if ! is_track_in_playlist(track_id, playlist_id)
            s *= " Past end, in 'recommendations'"
        end
    end
    s
end

function delete_current_playing_from_owned_context()
    st = get_player_state_print_feedback()
    isempty(st) && return false
    track_id = SpTrackId(st.item.uri)
    playing_now_desc = track_album_artists_string(st.item) # String for feedback
    if st.context.type == "collection"
        return delete_track_from_library(track_id, playing_now_desc)
    end
    if st.context.type !== "playlist"
        printstyled(stdout, "\n  Can't delete \"" * playing_now_desc * "\n  - Not currently playing from a known playlist or user's library.\n", color = :red)
        return ""
    end
    playlist_id = SpPlaylistId(st.context.uri)
    delete_track_from_own_playlist(track_id, playlist_id, playing_now_desc)
end

function pause_unpause()
    st = get_player_state_print_feedback()
    isempty(st) && return ""
    if st.is_playing
        player_pause()
        ""
    else
        player_resume_playback()
        ""
    end
end



function current_audio_features()
    st = get_player_state_print_feedback()
    isempty(st) && return ""
    curitem = st.item
    current_playing_id = curitem.id
    af = tracks_get_audio_features( current_playing_id)[1]
    isempty(af) && return ""
    s = ""
  s *= rpad("acousticness     $(af.acousticness)", 25)     * rpad("key               $(af.key)", 25) * "\n"
  s *= rpad("speechiness      $(af.speechiness)", 25)      * rpad("mode              $(af.mode)", 25) * "\n"
  s *= rpad("instrumentalness $(af.instrumentalness)", 25) * rpad("time_signature    $(af.time_signature)", 25) * "\n"
  s *= rpad("liveness         $(af.liveness)", 25)         * rpad("tempo             $(af.tempo)", 25)  * "\n"
  s *= rpad("loudness         $(af.loudness)", 25)         * rpad("duration_ms       $(af.duration_ms)", 25)   * "\n"     
  s *= "energy           $( af.energy)\n"
  s *= "danceability     $( af.danceability)\n"
  s *= "valence          $( af.valence)"
  s
end

"""
   seek_in_track(decile)

Resume playing from decile 0-9 in current track, where 1 is 1 / 10 of track length.
"""
function seek_in_track(decile)
    st = get_player_state_print_feedback()
    t = st.item.duration_ms
    new_progress_ms = Int(round(decile * t / 10))
    player_seek(new_progress_ms)
    ns = Int(round(new_progress_ms / 1000))
    ts = Int(round(t / 1000))
    "$(ns) s / $(ts) s"
end

include("_mini_player_replmode.jl")

# We ask for scopes (not including deleting tracks), at this point.
# It would be more irritating to get the pop-ups while playing.
mini_player_default_scopes = ["user-read-private", "user-modify-playback-state", "user-read-playback-state", "playlist-modify-private", 
                            "playlist-read-private", "playlist-read-collaborative", "user-library-read"]
if ! Spotify.credentials_contain_scope(mini_player_default_scopes)
    apply_and_wait_for_implicit_grant(;scopes= mini_player_default_scopes)
end
@info "Type : to enter mini player mode, e to exit."