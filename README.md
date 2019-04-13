# Pattle

  [![](https://img.shields.io/matrix/pattle:matrix.org.svg)](https://matrix.to/#/#pattle:matrix.org)
  

  Pattle is an easy to use Android app for Matrix, with
  design inspired by other popular IM apps.

  The goal of Pattle is to create an app that behaves similiary
  (and almost exactly) like many modern popular chat apps of today,
  like WhatsApp, Telegram and Signal. This is not the only goal,
  however: the primary goal of Pattle is to be a Matrix app that
  everyone can use, in terms of simplicity.

  For more details, see the
  [design philosophy](https://docs.pattle.im/design/philosophy/).

## Get Pattle
   
   Pattle is available on F-droid! To get it via F-droid, add the following repo:
   
   https://fdroid.pattle.im.

   The fingerprint is:

   `E9 1F 63 CA 6A E0 4F 8E 7E A5 3E 52 24 2E AF 87 79 55 92 09 B8 A3 42 F1 52 F9 E7 26 5E 3E A7 29`.

   Pattle will be available on Google Play when it's more stable.

   Pattle supports all Android version from 4.1 and up.

## Design

   All design decisions are documented on
   [docs.pattle.im](https://docs.pattle.im),
   [Design](https://docs.pattle.im/design/philosophy/).

## Contributing

   Before building a debug build, make sure you have a `.env` file in the
   root of the project. You can just `cp .env.example .env`, because
   Sentry is not used in debug mode.
   
   Contributions are encouraged! See [CONTRIBUTING](CONTRIBUTING.md) for
   details on how to contribute!

   For many features, contributions might also be needed for the
   [Matrix Dart SDK](https://git.pattle.im/pattle/library/matrix-dart-sdk),
   which is developed for Pattle.

## Building

   Pattle is made with [Flutter](https://flutter.dev/). To build Pattle,
   you'll need the [Flutter SDK](https://flutter.dev/docs/get-started/install).

   After the Flutter SDK is setup and ready, you can build Pattle with:
   `flutter build apk` for Android, or
   `flutter build ios` for iOS.
