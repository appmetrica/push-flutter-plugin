import 'appmetrica_push_api_pigeon.dart';

class AppMetricaPushInfo {

  final String? payload;

  AppMetricaPushInfo({
    this.payload
  });

  factory AppMetricaPushInfo.fromPigeon(AppMetricaPushInfoPigeon pigeon) {
    return AppMetricaPushInfo(
      payload: pigeon.payload,
    );
  }
}
