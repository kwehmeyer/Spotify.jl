"""
    urlstring

Encodes the arguments as expected in a query string.

Type info is seldom necessary, because the type of arguments
is given by the API endpoint.

Empty argument values => the argument name is considered redundant.
"""
function urlstring(;kwds...)
    isempty(kwds) && return ""
    urlstring(kwds)
end
function urlstring(kwds::Base.Pairs)
    iter = collect(kwds)
    parts = ["$(urlstring(k))=$(urlstring(v))" for (k,v) in iter if v !== "" && v !== 0 && v !== -1]
    join(parts, "&")
end

function urlstring(d::Dict)
    parts = ["$(urlstring(k))=$(urlstring(v))" for (k,v) in d if v !== "" && v !== 0 && v !== -1]
    s = join(parts, "&")
end
function urlstring(v::Vector)
    vs = urlstring.(v)
    join(vs, "%2C")
end
function urlstring(d::DateTime)
    string(d)[1:19] # Whole seconds
end
function urlstring(s)
    "$s"
end


"""
    body_string

Encodes the arguments as expected in a HTTP message body.

Type info and strurcture is in JSON format.

We define our own types through StructTypes and JSON3 in 'types.jl'.

Empty values => the key is also considered redundant.
"""
function body_string(;kwds...)
    dic = Dict(kwds)
    fi = filter(p -> p[2] !== 0 && !isempty(p[2]), dic)
    isempty(fi) && return ""
    body_string(fi)
end
function body_string(s)
    write(s)
end

"""
    build_query_string(xs::Vararg{String,N} where N)

Includes separators if needed, for urlstrings.
"""
function build_query_string(xs::Vararg{String,N} where N)
    sf = first(xs)
    if sf == ""
        throw("The first argument can not be an empty string")
    end
    others = filter( s -> s!== "", xs[2:end])
    if length(others) == 0
        return first(xs)
    end
    if sf[end] == '/' || sf[end] == '='
        sf * join(others, "&")
    else
        first(xs) * "?" * join(others, "&")
    end
end