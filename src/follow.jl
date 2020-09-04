# follow.jl
## https://developer.spotify.com/documentation/web-api/reference/follow/

#### GET ####

## https://developer.spotify.com/documentation/web-api/reference/follow/check-current-user-follows/
@docs """
# Check if Current User Follows Artists or Users
**Summary**: Check to see if the current user is following one or more artists or other Spotify Users

`type` _Required_: The ID type, either `artist` or `user`.\n 
`ids` _Required_: A comma separated list of the artist or user Spotify IDS to check. Maximum 50.\n 

[Reference](https://developer.spotify.com/documentation/web-api/reference/follow/check-current-user-follows/)
""" ->
function follow_check(type, ids)
    return spotify_request("me/following/contains?type=$type&ids=$ids")
end
