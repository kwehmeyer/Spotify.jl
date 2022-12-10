"""
    strip_embed_code(sdvs<substring>)
    -> Spid(<substring>)

Get the interesting part for pasting:
    
Spotify app -> Right click -> Share -> Copy embed code to clipboard
"""
strip_embed_code(s) = SpId(match(r"\b[a-zA-Z0-9]{22}", s).match)

