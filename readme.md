# Spotify.jl
An open-source interface for using the Spotify web API in Julia. 

## Progress...
Right now most of the endpoints have been written but some of the endpoints that require certain permissions might not be tested yet.
The brunt of the work (what I've been avoiding) that has still to be completed is in the authorization of the app.

## Authorization 
Ideally we can authorize completely from the Julia. The user will simply add their `client_id` and `client_secret` and the authorization code will authorize and refresh the tokens as needed. It would also be nice to have an easy way to change permissions for different authorization tokens. 

Right now we have a semi-automatic way of authorizing using the [Client Credentials](https://developer.spotify.com/documentation/general/guides/authorization-guide/#client-credentials-flow) flow but it has the major downside of not having settable permissions.

The goal is to have the [Authorization Code Flow](https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow) fully implemented in Julia.

# To Do
* Authorization
* Inline Documentation needs to be completed
* Wiki
* Write tests
* Set up CI
* Register the package  