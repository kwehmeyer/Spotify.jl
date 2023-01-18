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
using Spotify, Spotify.Player
using Base: text_colors
using REPL
using REPL.LineEdit
import JSON3
@info "Turning off detailed REPL logging"
LOG_request_string[] = false
LOG_authorization_field[] = false



function playffffffffnext()
    p = player_get_devices()[1].devices[1]
end
function string_current_playing()
    t = player_get_current_track()[1]
    if t != JSON3.Object()
        a = t.item.album.name
        ars = t.item.artists
        vs = [ar.name for ar in ars]
        t.item.name * " \\ " * a * " \\ " * join(vs, " & ")
    else
        "Not known"
    end
end
#=

@info strmenu
while true
    println(string_current_playing())
    #c = String(readline(stdin))
    c = read(stdin, Char)
    throwaway = readavailable(stdin)
    print(stdout, Base.text_colors[:magenta])
    show(stdout, MIME("text/plain"), c)
    print(stdout, Base.text_colors[:normal])
    printstyled("->  ", color=:green)
    if c == 'q'
        println("HA")
    end
    c == 'q' && break
    c == '\r' && break
    c == '\f' && player_skip_to_next()
    c == '\b' && player_skip_to_previous()

end
=#

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
    println(stdout, "$s ignored. Backspace exits. Otherwise, use arrow keys for playing!")
    print(stdout, text_colors[:green])
    println(stdout, "  " * string_current_playing())
    print(stdout, text_colors[:normal])
    nothing
end
miniprompt.on_done = REPL.respond(on_non_empty_enter, repl, miniprompt)

# We're going to wrap commands in this:

function wrap_command(state::REPL.LineEdit.MIState, repl::LineEditREPL, char::AbstractString)
    # write character typed into line buffer
    iobuffer = LineEdit.buffer(state)
    LineEdit.edit_insert(iobuffer, char)
    c = char[1]
    # change color of recognized character.
    if ! iscntrl(c)
       printstyled(c, color=:green)
    else
        show(stdout, MIME("text/plain"), c)
    end
    if c == 'b'
        player_skip_to_previous()
    elseif c == 'f'
        player_skip_to_next()
    end
end


# Single keystroke commands

#miniprompt.keymap_dict['f'] = (args...) -> begin;print(stdout, 'f');player_skip_to_next();end
miniprompt.keymap_dict['b'] = wrap_command
miniprompt.keymap_dict['f'] = wrap_command

#=
using REPL.TerminalMenus
mutable struct NoEnterMenu <: AbstractMenu
    pagesize::Int
    pageoffset::Int
end

REPL.TerminalMenus.keypress
=#