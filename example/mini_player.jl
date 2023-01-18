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
import JSON3
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
            "Not known"
        end
    else
        "Can't get state"
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
    t == JSON3.Object() && return false 
    cont = t.context
    cont.type !== "playlist" && return false
    playlist_id = cont.uri[end - 21:end]
    playlist_details = playlist_get(playlist_id)[1]
    id = playlist_details.owner.id
    id !== get_user_name() && return false
    tracksinlist =  playlist_get_tracks(playlist_id)[1]
    println(stdout, "TODO finish this")
    nothing
end

# We'll make a new REPL interface mode for this,
# based off the shell promt (shell mode would
# be entered by pressing ; at the julia> prompt).
# Method based on 
# https://erik-engheim.medium.com/exploring-julia-repl-internals-6b19667a7a62

repl = Base.active_repl;
shellprompt = repl.interface.modes[2]
miniprompt = REPL.Prompt("◍>")
for name in fieldnames(REPL.Prompt)
    if name != :prompt
        setfield!(miniprompt, name, getfield(shellprompt, name))
    end
end
push!(repl.interface.modes, miniprompt);

# To enter this mode, user must be at start of line, just as with the other
# interface modes.
function triggermini(state::LineEdit.MIState, repl::LineEditREPL, char::AbstractString)
    iobuffer = LineEdit.buffer(state)
    if position(iobuffer) == 0
        LineEdit.transition(state, miniprompt) do
            # Type of LineEdit.PromptState
            prompt_state = LineEdit.state(state, miniprompt)
            prompt_state.input_buffer = copy(iobuffer)
            s = string_current_playing()
            printstyled(stdout, "\n  " * s * '\n', color=:green)
        end
    else
        LineEdit.edit_insert(state, char)
    end
end

# Trigger mode transition to shell when a ':' is written
# at the beginning of a line
juliamode = repl.interface.modes[1]
juliamode.keymap_dict[':'] = triggermini

# So far the '◍>' mode is identical to 'shell>' mode.
#
# Be green, like Spotify:
miniprompt.prompt_prefix = text_colors[:green]

# Respond to pressing enter after typing:
function on_non_empty_enter(s)
    #println(stdout, "  $s ignored.")
    println(stdout, "  Backspace : exit "  )
    println(stdout, "  'f' or '→' : skip forward")
    println(stdout, "  'b' or '←' : skip back")
    println(stdout, "  'delete' or 'fn+delete' on mac: delete from playlist (if currently playing from user")
    print(stdout, text_colors[:green])
    println(stdout, "  " * string_current_playing())
    print(stdout, text_colors[:normal])
    nothing
end
miniprompt.on_done = REPL.respond(on_non_empty_enter, repl, miniprompt; pass_empty = true)

# We're going to wrap commands in this.
function wrap_command(state::REPL.LineEdit.MIState, repl::LineEditREPL, char::AbstractString)
    # This buffer contain other characters typed so far.
    iobuffer = LineEdit.buffer(state)
    # write character typed into line buffer
    LineEdit.edit_insert(iobuffer, char)
    # change color of recognized character.
    c = char[1]
    printstyled(stdout, char, color=:green)
    #println(stdout)
    if c == 'b' || char == "\e[D"
        player_skip_to_previous()
    elseif c == 'f' || char == "\e[C"
        player_skip_to_next()
    elseif char == "\e[3~"  || char == "\e\b"
        delete_current_from_own_playlist()
    end
    println(stdout, text_colors[:green])
    println(stdout, "  " * string_current_playing())
    println(stdout, text_colors[:normal])
end


# Single keystroke commands

miniprompt.keymap_dict['b'] = wrap_command
miniprompt.keymap_dict['f'] = wrap_command
controlkeydict = miniprompt.keymap_dict['\e']
arrowdict = controlkeydict['[']
arrowdict['C'] = wrap_command
arrowdict['D'] = wrap_command
deletedict = arrowdict['3']
deletedict['~'] =  wrap_command
