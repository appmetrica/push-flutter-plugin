import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push_plugin/src/appmetrica_push.dart';
import 'package:channel/channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'appmetrica_push_plugin_test.mocks.dart';

class MockHandler extends Mock {
  Future<ByteData?>? call(ByteData? message);
}

@GenerateMocks([AppMetricaConfig])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const codec = StandardMessageCodec();
  stubHandler(message) => Future.value(codec.encodeMessage([]));

  testWidgets('Test Activation', (WidgetTester tester) async {
    final mock = MockHandler();
    when(mock.call(any))
        .thenAnswer((_) => Future.value(codec.encodeMessage([])));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.activate', mock);
    await AppMetricaPush.activate();
    verify(mock.call(any));
  });

  testWidgets('Test Activation With Activated Metrica',
      (WidgetTester tester) async {
    final mock = MockHandler();
    final config = MockAppMetricaConfig();
    var apiKey = 'some api key';
    var configJson = "{\"apiKey\":\"$apiKey\"}";

    when(config.toJson())
        .thenAnswer((realInvocation) => Future.value(configJson));
    AppMetricaActivationConfigHolder.lastActivationConfig = config;
    when(mock.call(any)).thenAnswer(stubHandler);

    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.activate', stubHandler);
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.saveAppMetricaConfig', mock);
    await AppMetricaPush.activate();
    expect(
        codec.decodeMessage(verify(mock.call(captureAny)).captured.first).first,
        contains(apiKey));
  });

  testWidgets('Test Get Tokens', (WidgetTester tester) async {
    var tokens = {"service1": "token1", "service2": "token2"};
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.getTokens', (_) {
      return Future.value(codec.encodeMessage([tokens]));
    });
    expect(await AppMetricaPush.getTokens(), tokens);
  });

  testWidgets('Test Request Permissions', (WidgetTester tester) async {
    final mock = MockHandler();
    when(mock.call(any))
        .thenAnswer((_) => Future.value(codec.encodeMessage([])));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.requestPermission', mock);
    await AppMetricaPush.requestPermission(
        alert: false, badge: true, sound: true);
    verify(mock.call(any));
  });

  testWidgets('Test Token Stream', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.activate', stubHandler);
    var tokens = {"service1": "token1", "service2": "token2"};
    await AppMetricaPush.activate();
    final channel = Channel<Map<String, String?>>();
    AppMetricaPush.tokenStream.listen((event) => channel.send(event));
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.TokenUpdateApi.onTokenUpdated',
        codec.encodeMessage([tokens]),
        (data) {});
    expect((await channel.receive()).data, tokens);
  });

  testWidgets('Test Token Stream Multiple Subscribers',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.AppMetricaPushPigeon.activate', stubHandler);
    var tokens = {"service1": "token1", "service2": "token2"};
    await AppMetricaPush.activate();
    final channel = Channel<Map<String, String?>>();
    final anotherChannel = Channel<Map<String, String?>>();
    final firstSubscription =
        AppMetricaPush.tokenStream.listen((event) => channel.send(event));
    AppMetricaPush.tokenStream.listen((event) => anotherChannel.send(event));
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.TokenUpdateApi.onTokenUpdated',
        codec.encodeMessage([tokens]),
        (data) {});
    expect((await channel.receive()).data, tokens);
    expect((await anotherChannel.receive()).data, tokens);

    firstSubscription.cancel();

    var newTokens = {"service1": "newToken1", "service2": "newToken2"};
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.TokenUpdateApi.onTokenUpdated',
        codec.encodeMessage([newTokens]),
        (data) {});
    expect((await anotherChannel.receive()).data, newTokens);
  });
}
