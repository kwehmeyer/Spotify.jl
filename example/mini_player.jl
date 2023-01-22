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
using Spotify, Spotify.Player, Spotify.Playlists
using Base: text_colors
using REPL
using REPL.LineEdit
import Spotify.JSON3
@info "Turning off detailed REPL logging"
LOGSTATE.authorization = false
LOGSTATE.request_string = false
LOGSTATE.empty_response = false

function string_current_playing()
    # If we call player_get_current_track() right
    # after changing tracks, we might get the
    # previous state.
    # This otherwise useless call seems to
    # make Spotify return the currently playing song.
    st = player_get_state()[1]
    if st != JSON3.Object()
        t = player_get_current_track()[1]
        if t != JSON3.Object()
            a = t.item.album.name
            ars = t.item.artists
            vs = [ar.name for ar in ars]
            t.item.name * " \\ " * a * " \\ " * join(vs, " & ")
        else
            "Can't get current track"
        end
    else
        """Can't get Spotify state.  
           - Is $(Spotify.get_user_name()) running Spotify on any device? 
           - Has $(Spotify.get_user_name()) started playing any track?
        """
    end
end

function delete_current_from_own_playlist()
    # If we call player_get_current_track() right
    # after changing tracks, we might get the
    # previous state.
    # This otherwise useless call seems to
    # make Spotify return the currently playing song.
    st = player_get_state()[1]
    t = player_get_current_track()[1]
    if t == JSON3.Object()
        printstyled(stdout, "\n  Delete: Can't get currently playing track.\n", color=:red)
        return false
    end
    scur = string_current_playing()
    current_playing_id = t.item.id
    current_playing_uri = t.item.uri
    cont = t.context
    if isnothing(cont)
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - Not currently playing from a known playlist.\n", color=:red)
        return false
    end
    
    if cont.type !== "playlist"
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - Not currently playing from a playlist.\n", color=:red)
        return false
    end
    playlist_id = cont.uri[end - 21:end]
    playlist_details = playlist_get(playlist_id)[1]
    if playlist_details == JSON3.Object()
        printstyled(stdout, "\n  Delete: Can't get playlist details.\n", color=:red)
        return false
    end
    plo_id = playlist_details.owner.id
    user_id = Spotify.get_user_name()
    pll_name = playlist_details.name
    if plo_id !== String(user_id)
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - The playlist $pll_name is owned by $plo_id, not $user_id.\n", color=:red)
        return false
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
            return false
        else
            printstyled("The playlist's snapshot ID against which you deleted the track:\n  $(res.snapshot_id)", color = :green)
            return true
        end
    else
        printstyled(stdout, "\n  Can't delete " * scur * "\n  - Not part of current playlist $pll_name. Played too far?\n", color=:red)
        return false
    end
end

function pause_unpause()
    st = player_get_state()[1]
    if st != JSON3.Object()
        t = player_get_current_track()[1]
        if t != JSON3.Object()
            if t.is_playing
                player_pause()
                ""
            else
                player_resume_playback()
                ""
            end
        else
            "Can't get current track"
        end
    else
        """Can't get Spotify state.  
           - Is $(Spotify.get_user_name()) running Spotify on any device? 
           - Has $(Spotify.get_user_name()) started playing any track?
        """
    end
end

# TODO use this, generalize, drop fetching track since it's in st.item!
function get_state_print_feedback()
    st = player_get_state()[1]
    if st == JSON3.Object()
        print(stdout, """Can't get Spotify state.  
        - Is $(Spotify.get_user_name()) running Spotify on any device? 
        - Has $(Spotify.get_user_name()) started playing any track?
        """)
        return st, JSON3.Object()
    end
end
include("mini_player_replmode.jl")


@info "Press ':' on an empty 'julia> ' prompt to enter mini player"