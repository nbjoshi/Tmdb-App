
# TMDBI Companion - A Personalized Movie & TV Tracker

TMDB Companion is a Swift-based iOS application designed to help users explore, track, and manage their favorite movies and TV shows using data from The Movie Database (TMDB).

## Purpose
This app is built for movie and TV show enthusiasts who want a sleek, focused way to track what they watch, discover new content, and manage their favorites, all powered by a real user account from TMDB.
## Features

<img src="https://github.com/user-attachments/assets/fc1aee74-2869-4513-899f-ed6ccafe08fa" width="250" />
<img src="https://github.com/user-attachments/assets/c8424cf9-05f5-4a0e-96c2-cbd09af73097" width="250" />
<img src="https://github.com/user-attachments/assets/98916ad4-f5fb-4c33-8807-b602588c8eb9" width="250" />

Trending Feed: Browse trending movies and TV shows in real time.

Detailed Media Pages: View rich details like ratings, similar content, and user reviews.

Watchlist & Favorites: Logged-in users can add movies and shows to their personal watchlist or mark them as favorites.

Tabbed Navigation: Switch between Trending, Favorites, Watchlist, Search, and Profile via an intuitive tab bar.

Authentication: Secure TMDB login flow to fetch and manage user-specific data.

Responsive UI: Dark mode–friendly interface with adaptive layouts for iPhone and iPad.

Widget Support: Home screen widgets display current trending media using SwiftData.
## Tools and Technologies

SwiftUI – Declarative UI framework for building clean and responsive interfaces.

SwiftData – For lightweight local storage and widget data access.

TMDB API – Source of real-time movie & TV data, user state, and account management.

Async/Await + Task – Modern concurrency model to handle asynchronous network requests.

MVVM Architecture – Separation of concerns with ViewModel layers for fetching and formatting data.

WidgetKit – For dynamic home screen widgets integrated with trending content.
## Future

As the app continues to grow, I have several key improvements planned to elevate both the user experience and technical foundation:

Trailer & Video Playback: Integrate TMDB's video API to allow users to watch official trailers, teasers, and featurettes directly within the app.

User Ratings: Enable logged-in users to rate movies and TV shows, and display their submitted ratings throughout the app.

Custom Watchlists: Move beyond the default TMDB watchlist by allowing users to create and manage multiple custom lists (e.g., “Weekend Binge,” “Top Picks,” etc.).

Guest Sessions: Support anonymous usage through TMDB guest sessions so users can try the app without logging in.

UI Refresh: Redesign key views and navigation to give the app a more distinct look and feel, moving away from uniform styling to a more branded and visually diverse interface.

Codebase Refinement: Refactor the architecture to improve modularity, reusability, and maintainability, while also adopting SwiftUI best practices throughout the project.

Poster Recognition: Implement image recognition feature so that when users take a picture of a movie or tv show poster, the correct media pops up on the app. 

