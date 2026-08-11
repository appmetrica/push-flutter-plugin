```md
* Version heading: `## `{versionName}``
* Versions are sorted by semver (newest to oldest)
```

## `3.2.0`

## `3.1.0`

- Fix iOS UIScene conflict with other plugins (e.g. `firebase_messaging`): `scene:willConnectToSession:options:` no longer returns `YES`, so `connectionOptions` are not consumed and remain available to subsequent plugins.
- Updated supported [appmetrica_plugin](https://pub.dev/packages/appmetrica_plugin) version to `4.1.0`.

## `3.0.1`

- Fix `Could not resolve package dependencies` error while building with SPM.

## `3.0.0`

- Add UIScene lifecycle support for iOS. Launch push notification detection now works correctly in apps using UIScene (required by iOS 27+, default in Flutter 3.41+).
- Updated supported [appmetrica_plugin](https://pub.dev/packages/appmetrica_plugin) version to `4.0.0`.
- Update minimum Flutter version to 3.38.0 (Dart SDK 3.10.0).
- Add `AppMetricaPushInfo` to public API.
- The specification of the native SDK version for iOS has been improved: now it defines a range from the minimum version up to the next major version.
- Native SDK versions:
  - Android: 4.3.0
  - iOS: 3.4

## `2.4.0`

- Update AGP version to `8.2.0`.
- Add `AppMetricaPush.enableLogger` method.
- Update min sdk environment version to `2.15.0`.

## `2.3.0`

- Fix notification click processing.

## `2.2.0`

- Updated the minimum supported version of [appmetrica_plugin](https://pub.dev/packages/appmetrica_plugin) to `3.2.1`.
- Fix `file not found` error.

## `2.1.0`

- Support Swift Package Manager feature.
- Updated supported [appmetrica_plugin](https://pub.dev/packages/appmetrica_plugin) version to `3.2.0`.
- Support work with different push providers (Firebase, RuStore, HMS).
- Add method do get `payload` from notification.
- Native SDK versions:
  - Android: 4.1.1
  - iOS: ~> 3.1

## `2.0.0`

- Updated supported [appmetrica_plugin](https://pub.dev/packages/appmetrica_plugin) version to `3.0.0`.

## `1.0.0`

- Started using `flutter_lints` for checkstyle.
- Native SDK versions:
  - Android: 3.2.0
  - iOS: ~> 2.0

## `0.3.0`

- The native android part of the plugin was rewritten in java due to problems with kotlin versions.
- Updated dev dependencies.

## `0.2.0`

- Updated supported [appmetrica_plugin](https://pub.dev/packages/appmetrica_plugin) version to `1.0.1`.
- Updated native AppMetrica Push SDK versions:
  - Android: 2.2.0
  - iOS: ~> 1.3

## `0.1.0`

- Initial release with full support of AppMetrica Push SDK. Native SDK versions:
  - Android: 2.1.1
  - iOS: ~> 1.1
