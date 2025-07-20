A cross-platform real-time buzzer app for you and your friends to host quizzes,
games, and events.

# Features

- Real-time buzzer functionality
- Host a room and let players join using a join code
- Lockout: the first to buzz wins

# Development

The project is split into multiple repositories:

- [buzzer-frontend](https://github.com/fusselrulezz/buzzer-frontend) contains 
the frontend application, made with Flutter
- [buzzer-client-dart](https://github.com/fusselrulezz/buzzer-client-dart) is 
referenced by the frontend and provides a library for communicating with the backend
- [buzzer-server](https://github.com/fusselrulezz/buzzer-server) the ASP.NET Core Web API backend for this app.

To develop, you need [Flutter](https://flutter.dev/) on your machine. Have a
look at the [Installation Guide](https://docs.flutter.dev/get-started/install)
to get started. When you are finished, clone this repository and run 
`flutter pub get` to load the dependencies for this project.
To run, simply run `flutter run -d chrome` to launch the frontend in debug mode.