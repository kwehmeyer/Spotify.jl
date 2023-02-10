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

###

function bodystring(;kwds...)
    isempty(kwds) && return ""
    bodystring(kwds)
end
function bodystring(kwp::Pair)
    s = bodystring(kwp[1]) * ": " * bodystring(kwp[2])
    s
end
function bodystring(kwval::Vector)
    s = "["
    parts = ["$(bodystring(v))" for v in kwval]
    s *= join(parts, ", ")
    s *= "]"
    s
end
function bodystring(kwds::Base.Pairs)
    s = "{"
    parts = ["$(bodystring(p))" for p in kwds if p[2] !== "" && p[2] !== 0]
    s *= join(parts, ',')
    s *= "}"
    s
end
function bodystring(s::Symbol)
    "\"$s\""
end
function bodystring(d::Dict)
    vect = map(zip(keys(d), values(d))) do (k,v)
        Symbol(k) => convert(String, v)
    end
    bodystring(vect)
end
function bodystring(s::T) where T<: Union{SpUri, SpId, SpCategoryId, SpUserId, SpUrl, SpArtistId}
    "\"$(s.s)\""
end
function bodystring(s::String)
    if is_string_vector(s)
        "\"$s\""
    elseif is_string_separable(s)
        sv = "["
        parts = ["\"$(sp)\"" for sp in split(s, ',')]
        sv *= join(parts, ',')
        sv *= "]"
    else
        "\"$s\""
    end
end
function bodystring(s::Bool)
    "$s"
end
function bodystring(s::T) where T<:Number
    "$s"
end
is_string_vector(s::String) = startswith(s, '[') && endswith(s, ']')
is_string_separable(s::String) = (length(split(s, ',')) > 1)