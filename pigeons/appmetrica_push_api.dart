import 'package:pigeon/pigeon.dart';

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
