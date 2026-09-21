# Quiz App

Quiz App is a Flutter application for practicing knowledge through category-based quizzes. Users can create an account, sign in, browse quiz categories, answer questions, review results, and track their achievements. The app also includes profile management with optional profile images.

## Screenshots

![Screenshot 2026-09-21 142432](assets/images/screenshot/Screenshot%202026-09-21%20142432.png)
![Screenshot 2026-09-21 142444](assets/images/screenshot/Screenshot%202026-09-21%20142444.png)
![Screenshot 2026-09-21 142452](assets/images/screenshot/Screenshot%202026-09-21%20142452.png)
![Screenshot 2026-09-21 142555](assets/images/screenshot/Screenshot%202026-09-21%20142555.png)
![Screenshot 2026-09-21 142620](assets/images/screenshot/Screenshot%202026-09-21%20142620.png)
![Screenshot 2026-09-21 142700](assets/images/screenshot/Screenshot%202026-09-21%20142700.png)
![Screenshot 2026-09-21 142708](assets/images/screenshot/Screenshot%202026-09-21%20142708.png)
![Screenshot 2026-09-21 142714](assets/images/screenshot/Screenshot%202026-09-21%20142714.png)

## Features

- Onboarding, registration, and login
- Category browsing and quiz search
- Interactive quiz questions and answer selection
- Results summary after each quiz
- Achievement tracking
- Profile editing, bio, phone number, and profile image support
- Persistent authentication and profile data on the device
- Node.js authentication API backed by MySQL

## Technology Stack

- Flutter and Dart
- Node.js with Express
- MySQL with `mysql2`
- JWT authentication with `jsonwebtoken`
- Secure local storage with Flutter Secure Storage and Shared Preferences

## Project Structure

```text
lib/                    Flutter application source
	data/                 Quiz data
	models/               Quiz and result models
	screens/              App screens
	services/             Authentication and quiz persistence
	widgets/              Reusable UI components
authentication/         Express authentication server
assets/images/          App images and screenshots
test/                   Flutter tests
```

## Getting Started

### Flutter application

Prerequisites: Flutter SDK 3.11 or newer and a configured Android, iOS, web, or desktop device.

```bash
flutter pub get
flutter run
```

### Authentication server

The Flutter app expects the authentication API to run on port `5000`. Configure the database and JWT values in `authentication/.env` before starting the server.

```bash
cd authentication
npm install
npm start
```

For Android emulator testing, the app uses `10.0.2.2:5000` to reach the local server. Web builds use `localhost:5000`.

## Testing

Run the Flutter test suite with:

```bash
flutter test
```
