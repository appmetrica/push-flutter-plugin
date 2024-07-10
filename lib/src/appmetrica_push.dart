import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import 'appmetrica_push_api_pigeon.dart';

class _TokenUpdateImpl extends TokenUpdateApi {
  @override
  void onTokenUpdated(Map<String?, String?> newTokens) {
    AppMetricaPush._tokenStreamController
        .add(newTokens.map((key, value) => MapEntry(key as String, value)));
  }
}

/// Methods of the class are used for configuring the AppMetrica Push SDK library.
class AppMetricaPush {
  AppMetricaPush._();

  static final _appMetricaPush = AppMetricaPushPigeon();
  static final _tokenStreamController =
      StreamController<Map<String, String?>>.broadcast();

  /// Token update stream.
  static Stream<Map<String, String?>> get tokenStream =>
      _tokenStreamController.stream;

  /// Initializes the library in the app. Method should be invoked after initialization of the AppMetrica SDK.
  static Future<void> activate() {
    ActivationConfigHolder.activationListener = (metricaConfig) =>
        _saveAppMetricaConfigToPreferences(metricaConfig).ignore();

    _saveAppMetricaConfigToPreferences(ActivationConfigHolder.lastActivationConfig).ignore();
    TokenUpdateApi.setup(_TokenUpdateImpl());
    return _appMetricaPush.activate();
  }

  /// Requests permissions to
  /// * show [alert]
  /// * change counter on [badge]
  /// * play the notification [sound]
  ///
  /// Required only for iOS.
  static Future<void> requestPermission(
      {bool alert = false, bool badge = false, bool sound = false}) {
    return _appMetricaPush.requestPermission(
        PermissionOptions(alert: alert, badge: badge, sound: sound));
  }

  /// Returns a list of tokens for push providers that AppMetrica Push SDK was initialized with.
  static Future<Map<String, String?>> getTokens() =>
      _appMetricaPush.getTokens().then(
          (value) => value.map((key, value) => MapEntry(key as String, value)));

  static Future<void> _saveAppMetricaConfigToPreferences(
      final AppMetricaConfig? config) async {
    if (config != null) {
      return _appMetricaPush.saveAppMetricaConfig(await config.toJson());
    } else {
      return Future<void>.value();
    }
  }
}
