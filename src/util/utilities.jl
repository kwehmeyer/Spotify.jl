""""
    colored_repr(x)
    -> String

String which can be 'pretty-printed': colourful indication of types which after displaying
can still be copied for parsing as strings.
"""
function colored_repr(x)
    iob = IOBuffer()
    show(IOContext(iob, :color => true), "text/plain", x)
    '"' * String(take!(iob)) * '"'
end
function colored_repr(v::Vector)
    vs = colored_repr.(v)
    '[' * join(vs, ", ") * ']'
end
function colored_repr(t::Tuple)
    ts = colored_repr.(t)
    join(ts, ", ")
end
colored_repr(t::AbstractString) = '"' * t * '"'
colored_repr(d::Dict) = "Dict(" * colored_repr(pairs(d)...)
colored_repr(p::Pair) = colored_repr(p[1]) * " => " * colored_repr(p[2])

function assert_locale(locale)
    # Spotify ignores this incorrect value.
    locale == "en" && return nothing
    if locale != ""
        @assert occursin("_", locale)
        lang, langcountry = split(locale, '_')
        @assert lang == lowercase(lang)
        @assert langcountry == uppercase(langcountry)
    end
    nothing
end

# The below is about the select_calls()
# functionality.

"Sub-modules of Spotify, included ones that are not loaded. Exclude JSON3."
function module_symbols()
    allsymbs = names(Spotify, all = false)
    filter(allsymbs) do s
        s !== :Spotify && s !== :JSON3 && Spotify.eval(s) isa Module
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
    foos = function_symbols_in_module(m)
    length(foos) == 0 && return false
    f = first(foos)
    is_function_loaded(f)
end

function find_parameter_names(f)
    meths = methods(eval(f))
    @assert length(meths) == 1 "Expected one method defined for \n$meths \n - is semicolon missing in function signature?"
    meth = meths[1]
    sls =     split(meth.slot_syms, "\0"; keepempty = false)
    sls[2 : min(length(sls), meth.nargs )]
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
    # Find the values (the argument tuples). Build the dictionary.
    d = Dict{Symbol, Tuple}()
    for f in funcnames
        parameter_names = find_parameter_names(f)
        if length(parameter_names)> 0
            parameter_symbols = Symbol.(parameter_names)
            parameter_tuple = Tuple(parameter_symbols)
            push!(d, f => parameter_tuple)
        end
    end
    d
end


function default_values(argnames::NTuple{N, Symbol}) where N
    defaultvalue_by_paramname = DEFAULT_VALUES
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





"colored_function_call_string(loaded, funcsymb, names_by_func) - String"
function colored_function_call_string(loaded, funcsymb, names_by_func)
    if loaded
        argnames = get(names_by_func, funcsymb, ())
        argvals = default_values(argnames)
        colored_function_call_string(funcsymb, argvals)
    else
        "\e[31m $funcsymb \e[39m"
    end
end
"colored_function_call_string(funcsymb, argvals) -> String"
function colored_function_call_string(funcsymb, argvals)
    # with the large variation in function name lengths, it's better
    # to align lists on the first paranthesis.
    strf = lpad("$funcsymb", 32)
    "$strf($(colored_repr(argvals)))"
end






"menu_items(funcsymbs, funcloaded, names_by_func) -> Vector{String}"
function menu_items(funcsymbs, funcloaded, names_by_func)
    map(zip(funcsymbs, funcloaded)) do (f, loaded)
        colored_function_call_string(loaded, f, names_by_func)
    end
end

"Called by `select_functions`"
function function_menu(fs::Vector{Symbol})
    length(fs) == 0 && return fs
    ls = is_function_loaded.(fs)
    selected = [i for (i,l) in enumerate(ls) if l]
    names_by_func = argumentnames_by_function_dic()
    menuitems = menu_items(fs, ls, names_by_func)
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

"Called by `select_calls` after user interaction"
function make_default_calls_and_print(fs::Vector{Symbol})
    names_by_func =  argumentnames_by_function_dic()
    result = (JSON3.Object(), 0)
    for f in fs
        argnames = get(names_by_func, f, ())
        argvals = default_values(argnames)
        fexpr = Expr(:call, f, argvals...)
        # With:
        printstyled(stdout, "```julia-repl\n", color = :blue)
        printstyled(stdout, "julia> ", color = :blue)
        print(stdout, lstrip(colored_function_call_string(f, argvals)))
        println(stdout, "[1]")
        result = Main.eval(fexpr)
        display(result[1])
        if result[2] > 0
            println("Retry in $(result[2])")
        end
        printstyled("```\n", color = :blue)
        println("---------------------")
    end
    if length(fs) == 1
        println("Just one call was made; returning result.")
        return result[1]
    elseif length(fs) > 1
        println("Several calls made. The text syntax and result from each call was printed for copy / paste.")
    end
    return nothing
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
