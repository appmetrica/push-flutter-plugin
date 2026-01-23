import 'dart:async';

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

@GenerateMocks(<Type>[AppMetricaConfig])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const StandardMessageCodec codec = StandardMessageCodec();
  Future<ByteData?> stubHandler(ByteData? message) => Future<ByteData?>.value(codec.encodeMessage(<Object?>[]));

  testWidgets('Test Activation', (WidgetTester tester) async {
    final MockHandler mock = MockHandler();
    when(mock.call(any))
        .thenAnswer((Invocation _) => Future<ByteData?>.value(codec.encodeMessage(<Object?>[])));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate', mock.call);
    await AppMetricaPush.activate();
    verify(mock.call(any));
  });

  testWidgets('Test Activation With Activated Metrica',
      (WidgetTester tester) async {
    final MockHandler mock = MockHandler();
    final MockAppMetricaConfig config = MockAppMetricaConfig();
    const String apiKey = 'some api key';
    const String configJson = '{"apiKey":"$apiKey"}';

    when(config.toJson())
        .thenAnswer((Invocation realInvocation) => Future<String>.value(configJson));
    AppMetricaActivationConfigHolder.lastActivationConfig = config;
    when(mock.call(any)).thenAnswer((Invocation _) => stubHandler(null));

    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate', stubHandler);
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.saveAppMetricaConfig', mock.call);
    await AppMetricaPush.activate();
    expect(
        (codec.decodeMessage(verify(mock.call(captureAny)).captured.first as ByteData?) as List<Object?>).first,
        contains(apiKey));
  });

  testWidgets('Test Get Tokens', (WidgetTester tester) async {
    final Map<String, String> tokens = <String, String>{'service1': 'token1', 'service2': 'token2'};
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.getTokens', (ByteData? _) {
      return Future<ByteData?>.value(codec.encodeMessage(<Object?>[tokens]));
    });
    expect(await AppMetricaPush.getTokens(), tokens);
  });

  testWidgets('Test Request Permissions', (WidgetTester tester) async {
    final MockHandler mock = MockHandler();
    when(mock.call(any))
        .thenAnswer((Invocation _) => Future<ByteData?>.value(codec.encodeMessage(<Object?>[])));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.requestPermission', mock.call);
    await AppMetricaPush.requestPermission(
        alert: false, badge: true, sound: true);
    verify(mock.call(any));
  });

  testWidgets('Test Token Stream', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate', stubHandler);
    final Map<String, String> tokens = <String, String>{'service1': 'token1', 'service2': 'token2'};
    await AppMetricaPush.activate();
    final Channel<Map<String, String?>> channel = Channel<Map<String, String?>>();
    AppMetricaPush.tokenStream.listen((Map<String, String?> event) => channel.send(event));
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.appmetrica_push_plugin.TokenUpdateApi.onTokenUpdated',
        codec.encodeMessage(<Object?>[tokens]),
        (ByteData? data) {});
    expect((await channel.receive()).data, tokens);
  });

  testWidgets('Test Token Stream Multiple Subscribers',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate', stubHandler);
    final Map<String, String> tokens = <String, String>{'service1': 'token1', 'service2': 'token2'};
    await AppMetricaPush.activate();
    final Channel<Map<String, String?>> channel = Channel<Map<String, String?>>();
    final Channel<Map<String, String?>> anotherChannel = Channel<Map<String, String?>>();
    final StreamSubscription<Map<String, String?>> firstSubscription =
        AppMetricaPush.tokenStream.listen((Map<String, String?> event) => channel.send(event));
    AppMetricaPush.tokenStream.listen((Map<String, String?> event) => anotherChannel.send(event));
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.appmetrica_push_plugin.TokenUpdateApi.onTokenUpdated',
        codec.encodeMessage(<Object?>[tokens]),
        (ByteData? data) {});
    expect((await channel.receive()).data, tokens);
    expect((await anotherChannel.receive()).data, tokens);

    firstSubscription.cancel();

    final Map<String, String> newTokens = <String, String>{'service1': 'newToken1', 'service2': 'newToken2'};
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.appmetrica_push_plugin.TokenUpdateApi.onTokenUpdated',
        codec.encodeMessage(<Object?>[newTokens]),
        (ByteData? data) {});
    expect((await anotherChannel.receive()).data, newTokens);
  });
}
