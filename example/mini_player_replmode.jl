# This is included in 'mini_player.jl'
#
# We'll make a new REPL interface mode for this,
# based off the shell prompt (shell mode would
# be entered by pressing ; at the julia> prompt).
# Method based on 
# https://erik-engheim.medium.com/exploring-julia-repl-internals-6b19667a7a62

function print_menu()
    printstyled(stdout, "↑ or (↵ + ⌫) ", color= :bold)
    printstyled(stdout, ": Exit mode.", color = :light_black)
    printstyled(stdout, "  f or → ", color= :bold)
    printstyled(stdout, ": forward.", color = :light_black)
    printstyled(stdout, "  b or ← ", color= :bold)
    printstyled(stdout, ": back.\n", color= :light_black)
    printstyled(stdout, "       del or Fn + ⌫  ", color= :bold)
    printstyled(stdout, ": delete from own playlist.", color = :light_black)
    printstyled(stdout, " p  ", color= :bold)
    printstyled(stdout, ": pause / unpause\n", color = :light_black)
end
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
        if Spotify.credentials_still_valid()
            LineEdit.transition(state, miniprompt) do
                # Type of LineEdit.PromptState
                prompt_state = LineEdit.state(state, miniprompt)
                prompt_state.input_buffer = copy(iobuffer)
                print_menu()
                s = string_current_playing()
                printstyled(stdout, "\n  " * s * '\n', color=:green)
            end
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
    print_menu()
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
    elseif c == 'p'
        pause_unpause()
    elseif char == "\e[3~"  || char == "\e\b"
        delete_current_from_own_playlist()
    end
    println(stdout, text_colors[:green])
    println(stdout, "  " * string_current_playing())
    println(stdout, text_colors[:normal])
end


# Single keystroke commands
let
    miniprompt.keymap_dict['b'] = wrap_command
    miniprompt.keymap_dict['f'] = wrap_command
    miniprompt.keymap_dict['p'] = wrap_command
    # The structure is nested for special keystrokes.
    special_dict = miniprompt.keymap_dict['\e']
    very_special_dict = special_dict['[']
    very_special_dict['C'] = wrap_command
    very_special_dict['D'] = wrap_command
    deletedict = very_special_dict['3']
    deletedict['~'] =  wrap_command
end