using REPL.TerminalMenus
!endswith(pwd(), "test") && cd("test")
include("generalize_calls.jl")

is_loaded(foo) = isdefined(Main, foo)

# This menu needs to be updated quite manually, together with 
# verb_vec.jl and 'export_structure.jl. It would
# be nice if we could easily read which methods are loaded,
# but that would require some elaborate Core.eval...
# This 'problem' goes away when the list is complete!
function pick_modules(;verb_vec = verb_vec)
    !isdefined(Main, :Spotify) && return "-> using Spotify"
    submods = [:Albums, :Artists, :Browse, :Episodes, 
        :Follow, :Library, #:Markets,# 
        :Personalization, #:Player, :Playlists, #:Search,
        :Shows, :Tracks #, :UsersProfile, :Objects
    ]

    foodi = Dict{Int, UnitRange}(
            1 => 1:2,
            2 => 3:6,
            3 => 7:13,
            4 => 14:14,
            5 => 15:21,
            6 => 22:33,
            7 => 34:35,
            8 => 36:37,
            9 => 38:40)
    menuitems = String[]
    for ke in sort(collect(keys(foodi)))
        va = foodi[ke]
        str = "$va \t $(submods[ke])"
        if is_loaded(verb_vec[first(va)])
            push!(menuitems, str )
        else
            # Red color
            push!(menuitems, "\e[31m" * str * "\e[39m")
        end
    end
 
    menu = MultiSelectMenu(menuitems; pagesize = length(menuitems),charset = :unicode)
    selset = request("Pick group (red: module not loaded)", menu)
    feedback = String[]
    foos = []
    for i in selset
        addfoos = collect(foodi[i])
        if !is_loaded(verb_vec[first(addfoos)])
            m = submods[i]
            push!(feedback, " Spotify.$m")
        end
        foos = vcat(foos, addfoos)
    end
    if feedback != String[]
        fb = join(feedback, ", ")
        @error "Some submodules are not in scope. Try:\n using $fb"
        return Int[]
    else
        sort(foos)
    end
end
function pick_function(;verb_vec = verb_vec)
    subset = pick_modules(;verb_vec)
    if subset == Int[] 
        return
    end
    list = String[]
    for i in subset
        buf = IOBuffer()
        show_default_call(IOContext(buf, :color=>true)   , i)
        push!(list, lpad(string(i), 2) * " " * String(take!(buf)))
    end
    menu = RadioMenu(list; charset = :unicode, pagesize= length(list))
    listno =1
    while true
        listno = request("Pick function\n[press: enter = select, q=quit]", menu;cursor = listno)
        listno < 1 && break
        no = subset[listno]
        println()
        print("Now calling:\n\t  ")
        show_default_call(no)
        t0 = now()
        r = make_default_call(no)[1] # Disregard the second output, which is how many seconds to wait...
        t1 = now()
        display(r)
        println()
        println("Response after $(t1-t0)")
        println()
        r == () && break
    end
end
