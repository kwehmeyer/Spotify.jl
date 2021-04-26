"A stateful browser counter."
mutable struct Countbrowser;value::Int;end
(c::Countbrowser)() =COUNTBROWSER.value += 1
"For next value: COUNTBROWSER(). For current value: COUNTBROWSER.value"
COUNTBROWSER = Countbrowser(0)

"Get application path for developer applications"
function fwhich(s)
    fi = ""
    if Sys.iswindows()
        try
            fi = split(read(`where.exe $s`, String), "\r\n")[1]
            if !isfile(fi)
                fi = ""
            end
        catch
            fi =""
        end
    else
        try
            fi = readchomp(`which $s`)
        catch
            fi =""
        end
    end
    fi
end
function browser_path_unix_apple(shortname)
    trypath = ""
    if shortname == "chrome"
        if Sys.isapple()
            return "Google Chrome"
        else
            return "google-chrome"
        end
    end
    if shortname == "firefox"
        return "firefox"
    end
    if shortname == "safari"
        if Sys.isapple()
            return "safari"
        else
            return ""
        end
    end
    if shortname == "phantomjs"
        return fwhich(shortname)
    end
    return ""
end
function browser_path_windows(shortname)
    # windows accepts English paths anywhere.
    # Forward slash is acceptable too.
    trypath = ""
    homdr = ENV["HOMEDRIVE"]
    path32 = homdr * "/Program Files (x86)/"
    path64 = homdr * "/Program Files/"
    if shortname == "chrome"
        trypath = path64 * "Google/Chrome/Application/chrome.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Google/Chrome/Application/chrome.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "firefox"
        trypath = path64 * "Mozilla Firefox/firefox.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Mozilla Firefox/firefox.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "safari"
        trypath = path64 * "Safari/Safari.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Safari/Safari.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "iexplore"
        trypath = path64 * "Internet Explorer/iexplore.exe"
        isfile(trypath) && return trypath
        trypath = path32 * "Internet Explorer/iexplore.exe"
        isfile(trypath) && return trypath
    end
    if shortname == "phantomjs"
        return fwhich(shortname)
    end
    return ""
end
"Constructs launch command"
function launch_command(shortbrowsername; url = DEFAULT_REDIRECT_URI, privatemode = false)
    if Sys.iswindows()
        pt = browser_path_windows(shortbrowsername)
    else
        pt = browser_path_unix_apple(shortbrowsername)
    end
    pt == "" && return ``
    if shortbrowsername == "iexplore"
        prsw = "-private"
    else
        prsw = "--incognito"
    end
    if shortbrowsername == "phantomjs"
        if isdefined(:SRCPATH)
            script = joinpath(SRCPATH, "phantom.js")
        else
            script = "phantom.js"
        end
        return Cmd(`$pt $script $url`)
    else
        if Sys.iswindows()
            if privatemode
                return Cmd( [ pt, url, prsw])
            else
                return Cmd( [ pt, url])
            end
        else
            if Sys.isapple()
                if privatemode
                    return Cmd(`open --fresh -n $url -a $pt --args $prsw`)
                else
                    return Cmd(`open --fresh -n $url -a $pt`)
                end
            elseif Sys.islinux() || Sys.isbsd()
                return Cmd(`xdg-open $(url) $pt`)
            end
        end
    end
end


function open_on_page(shortbrowsername; url = DEFAULT_REDIRECT_URI)
    id = "open_on_page "
    dmc = launch_command(shortbrowsername; url)
    if dmc == ``
        @debug id, "Could not find ", shortbrowsername
        return false
    else
        try
            if shortbrowsername == "phantomjs"
                # Run enables text output of phantom messages in the REPL. In Windows
                # standalone REPL, run will freeze the main thread if not run async.
                @async run(dmc)
            else
                run(dmc, wait = false)
            end
        catch
            @debug id, "Failed to spawn ", shortbrowsername
            return false
        end
    end
    return true
end

"Try to open one browser from BROWSERS.
In some cases we expect an immediate indication
of failure, for example when the corresponding browser
is not found on the system. In other cases, we will
just wait in vain. In those cases,
call this function again after a reasonable timeout.
The function remembers which browsers were tried before.
"
function open_a_browser(;url = DEFAULT_REDIRECT_URI)
    id = "open_a_browser "
    if COUNTBROWSER.value > length(BROWSERS)
        return false
    end
    success = false
    b = ""
    while COUNTBROWSER.value < length(BROWSERS) && !success
        b = BROWSERS[COUNTBROWSER()]
        @debug id, "Trying to launch browser no. ", COUNTBROWSER.value, ", ",  b
        success = open_on_page(b, url = url)
    end
    if success
        @debug id, b, " on ", url, " seems to work."
    end
    success, b
end
function open_browser(b;url = DEFAULTURL)
    if b ∉ BROWSERS
        throw(ArgumentError("$b not in $BROWSERS"))
    end
    open_on_page(b, url = url)
end