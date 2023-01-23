# Use case 1:
# Cell phone and Spotify is connected to the stereo, 
# you're on zwift with sweaty hands but 
# can reach keys on keyboard with difficulty.
# 
# Use case 2: You hate the mouse, and hate leafing through 
# all of you open programs (but switching to another terminal 
# tab is OK.

# We can't read single keystrokes without adding dependencies
# so we'll just have to use 'Enter'.
using Spotify, Spotify.Player, Spotify.Playlists, Spotify.Tracks
using Base: text_colors
using REPL
using REPL.LineEdit
import Spotify.JSON3
@info "Turning off detailed REPL logging"
LOGSTATE.authorization = false
LOGSTATE.request_string = false
LOGSTATE.empty_response = false

"""
    get_state_print_feedback
    --> state object
Note: state contains the current track,
but it seems slow to update after changes.
"""
function get_state_print_feedback()
    st = player_get_state()[1]
    if st == JSON3.Object()
        print(stdout, """Can't get Spotify state.  
        - Is $(Spotify.get_user_name()) running Spotify on any device? 
        - Has $(Spotify.get_user_name()) started playing any track?
        """)
    end
    st
end

"""
    current_playing()
    -> String

Please wait 1 second after changes for correct info.
"""
function current_playing()
    st = get_state_print_feedback()
    st == JSON3.Object() && return ""
    current_playing(st.item)
end
function current_playing(item)
    # Ref. delay https://github.com/spotify/web-api/issues/821#issuecomment-381423071
    a = item.album.name
    ars = item.artists
    vs = [ar.name for ar in ars]
    item.name * " \\ " * a * " \\ " * join(vs, " & ")
end
function delete_current_from_own_playlist()
    st = get_state_print_feedback()
    st == JSON3.Object() && return false
    curitem = st.item
    scur = current_playing(curitem) # String for feedback
    current_playing_uri = curitem.uri
    cont = st.context
    if isnothing(cont)
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - Not currently playing from a known playlist.\n", color=:red)
        return ""
    end
    if cont.type !== "playlist"
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - Not currently playing from a playlist.\n", color=:red)
        return ""
    end
    playlist_id = cont.uri[end - 21:end]
    playlist_details = playlist_get(playlist_id)[1]
    if playlist_details == JSON3.Object()
        printstyled(stdout, "\n  Delete: Can't get playlist details.\n", color=:red)
        return ""
    end
    plo_id = playlist_details.owner.id
    user_id = Spotify.get_user_name()
    pll_name = playlist_details.name
    if plo_id !== String(user_id)
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - The playlist $pll_name is owned by $plo_id, not $user_id.\n", color=:red)
        return ""
    end
    tracksinlist =  playlist_get_tracks(playlist_id)[1]
    current_is_in_playlist = false
    i = 0
    for (i, pll_item) in enumerate(tracksinlist.items)
        if pll_item.track.id == current_playing_id
            current_is_in_playlist = true
            break
        end
    end
    if current_is_in_playlist
        printstyled(stdout, "Going to delete ... $current_playing_uri from $playlist_id \n", color = :yellow)
        res = playlist_remove_playlist_item(playlist_id; track_uris = [current_playing_uri])[1]
        if res == JSON3.Object()
            printstyled(stdout, "\n  Could not delete " * scur * "\n  from $pll_name. \n  This is due to technical reasons.\n", color=:red)
            return "✓"  
        else
            printstyled("The playlist's snapshot ID against which you deleted the track:\n  $(res.snapshot_id)", color = :green)
            return ""
        end
    else
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - Not part of current playlist $pll_name. Played too far?\n", color=:red)
        return ""
    end
end

function pause_unpause()
    st = get_state_print_feedback()
    st == JSON3.Object() && return ""
    if st.is_playing
        player_pause()
        ""
    else
        player_resume_playback()
        ""
    end
end

"""
    current_playlist()
    -> String

Please wait 1 second after changes for correct info.
"""
function current_playlist()
    st = get_state_print_feedback()
    st == JSON3.Object() && return ""
    current_playlist(st.context)
end
function current_playlist(cont)
    if isnothing(cont)
        return("Not currently playing from a known playlist.")
    end
    if cont.type !== "playlist"
        return("Not currently playing from a playlist.")
    end
    playlist_id = cont.uri[end - 21:end]
    pld = playlist_get(playlist_id)[1]
    if pld == JSON3.Object()
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
    s
end

function current_audio_features()
    st = get_state_print_feedback()
    st == JSON3.Object() && return ""
    curitem = st.item
    scur = current_playing(curitem) # String for feedback
    current_playing_id = curitem.id
    af = tracks_get_audio_features( current_playing_id)[1]
    af == JSON3.Object() && return ""
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
include("mini_player_replmode.jl")

@info "Type : to enter mini player mode."