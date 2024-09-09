import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/appmetrica_push_api_pigeon.dart',
  objcHeaderOut: 'ios/AppMetricaPushPlugin/AMPFPigeon.h',
  objcSourceOut: 'ios/AppMetricaPushPlugin/AMPFPigeon.m',
  objcOptions: ObjcOptions(prefix: 'AMPF'),
  javaOut: 'android/src/main/java/io/appmetrica/analytics/push/flutter/pigeon/Pigeon.java',
  javaOptions: JavaOptions(package: 'io.appmetrica.analytics.push.flutter.pigeon'),
))

class PermissionOptions {
  bool alert;
  bool badge;
  bool sound;
}

@HostApi()
abstract class AppMetricaPushPigeon {
  void activate();
  void saveAppMetricaConfig(String config);
  @async
  Map<String, String> getTokens();

  // only ios
  void requestPermission(PermissionOptions options);
}

@FlutterApi()
abstract class TokenUpdateApi {
  void onTokenUpdated(Map<String, String> newTokens);
}
