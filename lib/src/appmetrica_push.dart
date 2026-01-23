import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import 'appmetrica_push_api_pigeon.dart';
import 'appmetrica_push_info.dart';
import 'push_provider.dart';

class _TokenUpdateImpl extends TokenUpdateApi {
  @override
  void onTokenUpdated(Map<String?, String?> newTokens) {
    AppMetricaPush._tokenStreamController
        .add(newTokens.map((String? key, String? value) => MapEntry<String, String?>(key as String, value)));
  }
}

class _PushReceiverApiImpl extends PushReceiverApi {
  @override
  void onPushReceived(AppMetricaPushInfoPigeon pushInfoPigeon) {
    AppMetricaPush._pushInfoStreamController.add(AppMetricaPushInfo.fromPigeon(pushInfoPigeon));
  }
}

/// Methods of the class are used for configuring the AppMetrica Push SDK library.
class AppMetricaPush {
  AppMetricaPush._();

  static final AppMetricaPushPigeon _appMetricaPush = AppMetricaPushPigeon();
  static final StreamController<Map<String, String?>> _tokenStreamController =
      StreamController<Map<String, String?>>.broadcast();
  static final StreamController<AppMetricaPushInfo> _pushInfoStreamController =
      StreamController<AppMetricaPushInfo>.broadcast();

  /// Token update stream.
  static Stream<Map<String, String?>> get tokenStream =>
      _tokenStreamController.stream;

  /// Push info stream. New elements appear after user clicks on push notification.
  static Stream<AppMetricaPushInfo> get pushClickStream {
    return _pushInfoStreamController.stream;
  }

  /// Initializes the library in the app. Method should be invoked after initialization of the AppMetrica SDK.
  static Future<void> activate() {
    AppMetricaActivationConfigHolder.activationListener = (AppMetricaConfig? metricaConfig) =>
        _saveAppMetricaConfigToPreferences(metricaConfig).ignore();

    _saveAppMetricaConfigToPreferences(AppMetricaActivationConfigHolder.lastActivationConfig).ignore();
    TokenUpdateApi.setup(_TokenUpdateImpl());
    PushReceiverApi.setup(_PushReceiverApiImpl());
    return _appMetricaPush.activate();
  }

  /// Initializes the library in the app for specific notification providers.
  /// Method should be invoked after initialization of the AppMetrica SDK.
  static Future<void> activateWithProviders(List<PushProvider> providers) {
    AppMetricaActivationConfigHolder.activationListener = (AppMetricaConfig? metricaConfig) =>
        _saveAppMetricaConfigToPreferences(metricaConfig).ignore();

    _saveAppMetricaConfigToPreferences(AppMetricaActivationConfigHolder.lastActivationConfig).ignore();
    TokenUpdateApi.setup(_TokenUpdateImpl());
    PushReceiverApi.setup(_PushReceiverApiImpl());
    return _appMetricaPush.activateWithProviders(providers.map((PushProvider provider) => provider.nativeFactoryClass).toList());
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
          (Map<String?, String?> value) => value.map((String? key, String? value) => MapEntry<String, String?>(key as String, value)));

  /// Returns push info of push notification that launched application.
  static Future<AppMetricaPushInfo> getLaunchPushInfo() =>
      _appMetricaPush.getLaunchPushInfo().then((AppMetricaPushInfoPigeon value) => AppMetricaPushInfo.fromPigeon(value));

  /// Enables public logs.
  static Future<void> enableLogger() => _appMetricaPush.enableLogger();

  static Future<void> _saveAppMetricaConfigToPreferences(
      final AppMetricaConfig? config) async {
    if (config != null) {
      return _appMetricaPush.saveAppMetricaConfig(await config.toJson());
    } else {
      return Future<void>.value();
    }
  }
}
