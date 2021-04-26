using Spotify
using Spotify.JSON3
using Dates: now
!endswith(pwd(), "test") && cd("test")
"""
- 1-2   Albums 
- 3-6   Artists  
- 8-13  Browse 
- 14    Episodes 
- 15-21 Follow 
- 22-33 Library 
- 34-35 Personalization 
- 36-37 Player 
- 38-40 Playlists
- Search 
- Shows 
- Tracks 
- UsersProfile 
- Objects 
"""
verb_vec = include("verb_vec.jl")
tuples_vec = include("parameter_tuples_vec.jl")
param_dic = include("parameter_default_dic.jl")
get_defaults_tuple(tu) = map(x -> param_dic[x], tu)
get_defaults_tuple(tu::Symbol) = (param_dic[tu],)


function get_default_call_expression(n)
    verb = verb_vec[n]
    tup = tuples_vec[n]
    defatup = get_defaults_tuple(tup)
    Expr(:call, verb, defatup...)
end


"""
    make_default_call(n)

Make Spotify API call number n, ref. 'verb_vec'.
"""
make_default_call(n) = eval(get_default_call_expression(n))

"""
    show_default_call(n)
    show_default_call(io::IO, n)

Show Spotify API call number n, ref. 'verb_vec'.
"""
function show_default_call(n) 
    show(stderr, get_default_call_expression(n))
    print(stderr, "\n")
end
show_default_call(io::IO, n) = show(io, get_default_call_expression(n))
