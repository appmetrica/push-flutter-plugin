import 'push_provider.dart';

class FirebasePushProvider extends PushProvider {
  @override
  String get nativeFactoryClass => "io.appmetrica.analytics.push.flutter.FirebasePushProviderFactory";
}
