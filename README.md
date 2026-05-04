# Vibez

This project collaborative music app was developed for the Mobile App Development course. This app allows users to create a new listening session where they can vote on which songs they'd like to listen to. 

## App Setup

Follow these steps to run the app:
- Clone this repository
- Commit changes
- Run "flutter run" in your terminal

## App Navigation
- Home tab - create a new listening session, join an existing session, or view recommended tracks based on listening
- Playlists tab - view all sessions
- Profile - view user information and set app preferences

## Known Issues
- Get track recommendations - Spotify API endpoint for artist's top tracks is deprecated, so must find another endpoint to use for recommended tracks
- No 'create session' button on Playlists tab - must add create session button to Playlists tab for enhances UX experience
- No distinct users - the app renders the same information to all users. Must separate each individual user information

 ## Future Enhancements
 - Updated UI - The current UI is a skeleton and was used for testing purposes only. Would like to improve the UI to give the app a modern, more completed feel
 - Get Recommended Tracks - Return list of recommended tracks and artists for users based on their listening history
 - Implement chatroom - Implement chatroom feature so users can collaborate on which tracks they'd like to add to the queue
 - Search sessions - As the app grows, it would be nice if users could search for their saved session instead of manually searching for it
 - Create 'users' table - The app successfully creates new userse, but user specific information should be stored in the app (such as name, username, and app preferences)
