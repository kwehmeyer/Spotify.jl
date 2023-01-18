"""
    strip_embed_code(sdvs<substring>)
    -> Spid(<substring>)

Get the interesting part for pasting:
    
Spotify app -> Right click -> Share -> Copy embed code to clipboard
"""
strip_embed_code(s) = SpId(match(r"\b[a-zA-Z0-9]{22}", s).match)




# The below is about the select_calls()
# functionality.

"Sub-modules of Spotify, included ones that are not loaded"
function module_symbols()
    allsymbs = names(Spotify, all = false)
    filter(allsymbs) do s
        s !== :Spotify && Spotify.eval(s) isa Module
    end
end
function function_symbols_in_module(s::Symbol)
    m = Spotify.eval(s)
    @assert m isa Module
    filter(n-> n !== s,  names(m, all = false))
end
function function_symbols_in_module(ms::Vector{Symbol})
    fs = Vector{Symbol}()
    for m in ms
        fs = vcat(fs, function_symbols_in_module(m))
    end
    fs
end


"""
   is_function_loaded(foo::Symbol)
   
```julia-repl
julia> using Spotify.Library
julia> Spotify.is_function_loaded(:library_get_saved_shows)
true

julia> Spotify.is_function_loaded(:markets_get)
false
```
"""
is_function_loaded(foo::Symbol) = isdefined(Main, foo)

"""
   is_module_loaded(foo::Symbol)
   
```julia-repl
julia> using Spotify.Library
julia> Spotify.is_module_loaded(:Library)
true

julia> Spotify.is_module_loaded(:Artists)
false
```
"""
function is_module_loaded(m::Symbol)
    f = first(function_symbols_in_module(m))
    is_function_loaded(f)
end

# Build a dictionary of implemented functions and their
# argument names.
function argumentnames_by_function_dic()
    # Find the keys
    submods = module_symbols()
    funcnames = Vector{Symbol}()
    for submod in submods
        funcnames = vcat(funcnames, function_symbols_in_module(submod))
    end
    # Build the dictionary.
    d = Dict{Symbol, Tuple}()
    for f in funcnames
        meths = methods(eval(f))
        @assert length(meths) == 1 "Expected one method defined for \n$meths \n - is semicolon missing in function signature?"
        str = meths[1].slot_syms
        str1 = replace(str, "#self#" => "")
        parameter_names = split(str1, "\0"; keepempty = false)
        if length(parameter_names)> 0
            parameter_symbols = Symbol.(parameter_names)
            parameter_tuple = Tuple(parameter_symbols)
            push!(d, f => parameter_tuple)
        end
    end
    d
end

function default_values(argnames::NTuple{N, Symbol}) where N
    defaultvalue_by_paramname = include(joinpath(@__DIR__, "../lookup/paramname_default_dic.jl"))
    map(pnam -> get(defaultvalue_by_paramname, pnam, ""), argnames)
end
function default_values(argnames::Tuple{})
    ()
end

"Called by `select_functions`"
function module_menu()
    sms = sort(module_symbols())
    ls = is_module_loaded.(sms)
    selected = [i for (i,l) in enumerate(ls) if l]
    menuitems = map(zip(sms, ls)) do (m, loaded)
        if loaded
            "$m"
        else
            "\e[31m $m \e[39m"
        end
    end
    menu = MultiSelectMenu(menuitems;  selected, pagesize = length(menuitems), charset = :unicode)
    msg = "Pick submodule "
    if  !all(ls)
        msg *= "(\e[31mred\e[39m: not loaded)"
    end
    selset = request(msg, menu)
    selected_but_not_loaded = setdiff(selset, selected)
    if length(selected_but_not_loaded) > 0
        mlist = join([sms[i] for i in selected_but_not_loaded], ", Spotify.")
        @warn "You may want to: \n using Spotify.$mlist\n\n You may browse functions in these modules per now."
    end
    sort([sms[i] for i in selset])
end

"Called by `select_functions`"
function function_menu(fs::Vector{Symbol})
    length(fs) == 0 && return fs
    ls = is_function_loaded.(fs)
    selected = [i for (i,l) in enumerate(ls) if l]
    names_by_func = argumentnames_by_function_dic()
    menuitems = map(zip(fs, ls)) do (f, loaded)
        if loaded
            strf = lpad("$f", 32)
            argnames = get(names_by_func, f, ())
            argvals = default_values(argnames)
            "$strf   $(lpad("$argnames", 43))   $argvals"
        else
            "\e[31m $f \e[39m"
        end
    end
    menu = MultiSelectMenu(menuitems; selected, pagesize = length(menuitems), charset = :unicode)
    msg = "Pick function "
    if  !all(ls)
        msg *= "(\e[31mred\e[39m: not loaded)"
    end
    selset = request(msg, menu)
    selected_but_not_loaded = setdiff(selset, selected)
    if length(selected_but_not_loaded) > 0
        flist = join([fs[i] for i in selected_but_not_loaded], ", ")
        @warn "Ignoring unloaded functions: \n $flist"
    end
    selected_loaded = setdiff(selset, selected_but_not_loaded)
    sort([fs[i] for i in selected_loaded])
end
"""
    select_functions()

Pick a subset of loaded functions for calling in sequence with default arguments.
"""
function select_functions()
    mods = module_menu()
    fs = function_symbols_in_module(mods)
    function_menu(fs)
end
print_as_console_input(io::IO, argval) = show(io, MIME("text/plain"), argval)
function print_as_console_input(io::IO, v::Vector)
    print(io, "\"")
    for val in v[1:end - 1]
        show(io, val)
        print(io, ", ")
    end
    show(io, last(v))
    print(stdout, "\"")
end
function print_as_console_input(io::IO, fexpr::Expr)
    printstyled(io, "julia> ", color=:blue)
    f = fexpr.args[1]
    print(io, "$f(")
    if length(fexpr.args) == 1
        # OK, just checking
    elseif length(fexpr.args) == 2
        argvals = fexpr.args[2]
        print_as_console_input(io, argvals)
    elseif length(fexpr.args) > 2
        argvals = fexpr.args[2:end]
        for val in argvals[1:end-1]
            print_as_console_input(io, val)
            print(io, ", ")
        end
        print_as_console_input(io, last(argvals))
    else
        throw("unexpected")
    end
    # The second output argument is hardly ever interesting,
    # provided that we have implicit user grant. This
    # is different when experimenting with app credentials
    # only. So we keep the inelegant tuple output forms for now.
    println(stdout, ")[1]")
end

function make_default_calls_and_print(fs::Vector{Symbol})
    names_by_func =  argumentnames_by_function_dic()
    result = (JSON3.Object(), 0)
    for f in fs
        argnames = get(names_by_func, f, ())
        argvals = default_values(argnames)
        fexpr = Expr(:call, f, argvals...)
        printstyled(stdout, "```julia-repl\n", color=:blue)
        print_as_console_input(stdout, fexpr)
        result = Main.eval(fexpr)
        display(result[1])
        if result[2] > 0
            println("Retry in $(result[2])")
        end
        printstyled("```\n", color=:blue)
        println("---------------------")
    end
    if length(fs) == 1
        println("Just one call was made; returning result.")
        return result[1]
    else
        println("Several calls made. The text syntax and result from each call was printed for copy / paste.")
        return nothing
    end
end

"""
    select_calls()

Open an interactive menu in the console. User picks modules, then functions 
in those. Calls are made with default arguments, defined in 
`src/lookup/paramname_default_dic`.

Console output is formatted for pasting  into inline documentation.
"""
function select_calls()
    fs = select_functions()
    make_default_calls_and_print(fs)
end
