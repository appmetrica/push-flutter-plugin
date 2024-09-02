# AppMetrica Push SDK for Flutter

A Flutter plugin for AppMetrica Push SDK by Yandex. Allows you to send push notifications to sophisticated user segments, flexibly adjust timing and A/B test your campaigns. The number of push notifications is unlimited.

## Supported Features

* Flexible targeting. Use all the data about your users processed by AppMetrica to create sophisticated segments for personalized communication.
* A/B testing. Try out different combinations of push content for the same audience, or test responses from different user segments.
* Feature-rich push composer. All content of a push notification can be customized — you can vary different combinations of texts, pics, icons, and calls to action.
* Scheduling. All push notifications can be scheduled to pop up at a specific time according to the time zone of the recipients.
* Push API. Send individual notifications using custom triggers, including events outside the app.
* Detailed stats. To carefully evaluate your push campaign’s efficiency, you can trace how each push affected user behavior, and match your push campaign with your key metrics.

## Getting Started

In your flutter project add the following dependency:
```
dependencies:
  ...
  appmetrica_push_plugin: ^2.1.0
```

Activate [AppMetrica SDK for Flutter](https://pub.dev/packages/appmetrica_plugin) using `AppMetrica.activate` with your API Key
```
AppMetrica.activate(AppMetricaConfig("insert_your_api_key_here"));
```

Activate AppMetrica Push SDK using `AppMetricaPush.activate` and subscribe for tokens via `AppMetricaPush.tokenStream`

```
AppMetricaPush.activate();
AppMetricaPush.tokenStream.listen((tokens) {
  // handle new tokens
});
```

Complete integration with connection of push transport for all target platforms according to its documentation.

## Suggesting improvements
To file bugs, make feature requests, or to suggest other improvements, please use the [feedback form](https://appmetrica.io/docs/en/troubleshooting/index).

## Notes
Activation of [AppMetrica SDK for Flutter](https://pub.dev/packages/appmetrica_plugin) is required for AppMetrica Push SDK for Flutter to work correctly.

This plugin uses [Pigeon](https://pub.dev/packages/pigeon) to generate interfaces for communication between Flutter and host platform.

