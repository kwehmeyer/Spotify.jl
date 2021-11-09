# First Steps

## Obtaining API Keys 

Visit [the Spotify developer website](https://developer.spotify.com) and login/register.

Once registered visit your dashboard and "Create an App". Call it whatever you want!

### Redirect URI

Open the *app* and edit the settings. In the field where it asks for **Redirect URI** enter `http://127.0.0.1:8080`.

## Setting credentials

When you first run

```julia
using Spotify
```

Spotify.jl will create an `.ini` file in your home directory. This is where you will insert your Client ID, Client Secret, and your Spotify username.


!!! warning "Sensitive Information"
     Do not share you credentials with anyone. The `.ini` file is placed in your homedir as means to seperate your credentials from being shared along with your code!

```
   [User procedure:]
  1 1: How to get the CLIENT_ID=Developer.spotify.com -> Dashboard -> log in -> 
  2 2: How to get CLIENT_SECRET=When you have client id, press 'Show client secr
  3 3: How to give REDIRECT_URL=Still in the app dashboard:
  4     'Edit settings' -> Redirect uris -> http://127.0.0.1:8080 -> Save change
  5 [Spotify developer's credentials]
  6 CLIENT_ID=YOUR_CLIENT_ID
  7 REDIRECT_URI=http://127.0.0.1:8080
  8 CLIENT_SECRET=YOUR_CLIENT_SECRET
  9 [Spotify user id]
 10 user_name=YOUR_USERNAME
 ```

 Now you are ready to try running a command. For example getting 20 of your saved tracks
 ```
 Spotify.Library.library_get_saved_tracks()
[ Info: Starting asyncronous user authorization process. Try again later!
	Listening for authorization on 127.0.0.1:8080 and path 
	Launching a browser at: https://accounts.spotify.com/authorize?client_id=86e72e3fb91149d395088fdd0234f44d&redirect_uri=http:%2F%2F127.0.0.1:8080&scope=user-read-private%20user-read-email%20user-follow-read%20user-library-read&show_dialog=true&response_type=token&state=987
	Trying to launch browser candidate: firefox
[ Info: Waiting for 15 seconds
```

!!! tip "Browser not opening?"
    If a browser does not open asking you to allow **your** API to access you account data, then simply run the command again and visit the link that is output by the REPL

Once the website opens and you allow the API to query your data you will be redirected to the `http://127.0.0.1:8080` page. You can close the window and query. Credentials typically last about an hour before needing to be refreshed.


