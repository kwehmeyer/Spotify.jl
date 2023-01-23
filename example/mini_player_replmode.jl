# This is included in 'mini_player.jl'
#
# We'll make a new REPL interface mode for this,
# based off the shell prompt (shell mode would
# be entered by pressing ; at the julia> prompt).
# Method based on 
# https://erik-engheim.medium.com/exploring-julia-repl-internals-6b19667a7a62

function print_menu()
    l = text_colors[:light_black]
    b = text_colors[:bold]
    n = text_colors[:normal]
    menu = """
       ¨e : exit mode.       ¨f or ¨→ : forward.    ¨b or ¨← : back.  ¨p: pause / unpause.
       ¨del or ¨fn + ¨⌫ : delete from own playlist. ¨l: playlist.    ¨a: audio features.
    """
    menu = replace(menu, "¨" => b , ":" =>  "$n$l:", "." => ".$n", " or" => "$n$l or$n", "+" => "$n+")
    print(stdout, menu)
    print(stdout, n)
end

# How we will respond to pressing enter when in mini player mode
function on_non_empty_enter(s)
    print_menu()
    print(stdout, text_colors[:green])
    println(stdout, "  " * current_playing())
    print(stdout, text_colors[:normal])
    nothing
end



# To enter this new repl mode 'minimode', user must be at start of line, just as with the other
# interface modes.
function triggermini(state::LineEdit.MIState, repl::LineEditREPL, char::AbstractString)
    iobuffer = LineEdit.buffer(state)
    if position(iobuffer) == 0
        if Spotify.credentials_still_valid()
            LineEdit.transition(state, miniprompt) do
                # Type of LineEdit.PromptState
                prompt_state = LineEdit.state(state, miniprompt)
                prompt_state.input_buffer = copy(iobuffer)
                println(stdout)
                print_menu()
                s = current_playing()
                printstyled(stdout, "\n  " * s * '\n', color=:green)
            end
        end
    else
        LineEdit.edit_insert(state, char)
    end
end

function exit_mini_to_julia_prompt(state::LineEdit.MIState, repl::LineEditREPL, char::AbstractString)
    # Other mode changes require start of line. We want immediate exit.
    iobuffer = LineEdit.buffer(state)
    LineEdit.transition(state, repl.interface.modes[1]) do
        # Type of LineEdit.PromptState
        prompt_state = LineEdit.state(state, miniprompt)
        prompt_state.input_buffer = copy(iobuffer)
    end
end

# We assume there are six default prompt modes, like in Julia 1.0-1.8 at least.
function add_seventh_prompt_mode()
    freshprompt = REPL.Prompt(" ◍ >")
    repl = Base.active_repl
    # Copy every property of the shell mode to freshprompt
    shellprompt = repl.interface.modes[2]
    for name in fieldnames(REPL.Prompt)
        if name == :prompt
        elseif name == :prompt_prefix
            setfield!(freshprompt, name, text_colors[:green])
        elseif name == :on_done
            setfield!(freshprompt, name, REPL.respond(on_non_empty_enter, repl, freshprompt; pass_empty = true))
        elseif name == :keymap_dict
             # Note: We don't want to copy the keymap reference from shell
            # mode, because we're going to tweak some keys later,
            # and don't want to affect other modes.
            # The default keymap is fine, though it misses a mode exit.
            # We add this important one here, at once.
            # Other keys are added after this.
            freshprompt.keymap_dict['e'] = exit_mini_to_julia_prompt
        else
            setfield!(freshprompt, name, getfield(shellprompt, name))
        end
    end
    if length(repl.interface.modes) == 6
        # Add freshprompt as the seventh
        push!(repl.interface.modes, freshprompt)
    else
        # This has been run twice.
        # Replace old with new.
        repl.interface.modes[7] = freshprompt
    end

    # Modify juliamode to trigger mode transition to minimode 
    # when a ':' is written at the beginning of a line
    juliamode = repl.interface.modes[1]
    juliamode.keymap_dict[':'] = triggermini
    freshprompt
end

# Configure miniprompt, then tell Julia about it. 
const miniprompt = add_seventh_prompt_mode() 


# We're going to wrap mini mode commands in this.
# That means a shortcut is defined in keymap_dict, but
# what it does is specificed here.
function wrap_command(state::REPL.LineEdit.MIState, repl::LineEditREPL, char::AbstractString)
    # This buffer contain other characters typed so far.
    iobuffer = LineEdit.buffer(state)
    # write character typed into line buffer
    LineEdit.edit_insert(iobuffer, char)
    # change color of recognized character.
    printstyled(stdout, char, color=:green)
    c = char[1]
    if c == 'b' || char == "\e[D"
        player_skip_to_previous()
            # If we call player_get_current_track() right
            # after changing tracks, we might get the
            # previous state.
            # Ref. https://github.com/spotify/web-api/issues/821#issuecomment-381423071
            sleep(1)
    elseif c == 'f' || char == "\e[C"
        player_skip_to_next()
        # Ref. https://github.com/spotify/web-api/issues/821#issuecomment-381423071
        sleep(1)
    elseif c == 'p'
        pause_unpause()
    elseif c == 'l'
        println(stdout, text_colors[:light_blue])
        print(stdout, "  " * current_playlist())
        println(stdout, text_colors[:normal])
    elseif char == "\e[3~"  || char == "\e\b"
        delete_current_from_own_playlist()
    elseif c == 'a'
        println(stdout, text_colors[:light_blue])
        print(stdout, current_audio_features())
        println(stdout, text_colors[:normal])
    end
    println(stdout, text_colors[:green])
    print(stdout, "  " * current_playing())
    println(stdout, text_colors[:normal])
end

# Single keystroke commands
let
    miniprompt.keymap_dict['b'] = wrap_command
    miniprompt.keymap_dict['f'] = wrap_command
    miniprompt.keymap_dict['p'] = wrap_command
    miniprompt.keymap_dict['l'] = wrap_command
    miniprompt.keymap_dict['a'] = wrap_command
    # The structure is nested for special keystrokes.
    special_dict = miniprompt.keymap_dict['\e']
    very_special_dict = special_dict['[']
    very_special_dict['C'] = wrap_command
    very_special_dict['D'] = wrap_command
    deletedict = very_special_dict['3']
    deletedict['~'] =  wrap_command
end