import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push_plugin/src/appmetrica_push.dart';
import 'package:appmetrica_push_plugin/src/appmetrica_push_api_pigeon.dart';
import 'package:appmetrica_push_plugin/src/appmetrica_push_info.dart';
import 'package:appmetrica_push_plugin/src/firebase_push_provider.dart';
import 'package:channel/channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockHandler extends Mock {
  Future<ByteData?>? call(ByteData? message);
}

@GenerateMocks(<Type>[AppMetricaConfig])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const StandardMessageCodec codec = StandardMessageCodec();
  const MessageCodec<Object?> pigeonCodec = AppMetricaPushPigeon.codec;
  const MessageCodec<Object?> pushReceiverCodec = PushReceiverApi.codec;
  Future<ByteData?> stubHandler(ByteData? message) =>
      Future<ByteData?>.value(codec.encodeMessage(<Object?>[]));

  testWidgets('Test Activation', (WidgetTester tester) async {
    final MockHandler mock = MockHandler();
    when(mock.call(any))
        .thenAnswer((Invocation _) => Future<ByteData?>.value(codec.encodeMessage(<Object?>[])));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate', mock.call);
    await AppMetricaPush.activate();
    verify(mock.call(any));
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

  testWidgets('activateWithProviders sends Firebase nativeFactoryClass',
      (WidgetTester tester) async {
    List<Object?>? receivedProviders;
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activateWithProviders',
        (ByteData? message) {
      final List<Object?> args = pigeonCodec.decodeMessage(message)! as List<Object?>;
      receivedProviders = args[0] as List<Object?>?;
      return Future<ByteData?>.value(pigeonCodec.encodeMessage(<Object?>[]));
    });

    await AppMetricaPush.activateWithProviders(<FirebasePushProvider>[FirebasePushProvider()]);

    expect(receivedProviders, <String>[
      'io.appmetrica.analytics.push.flutter.FirebasePushProviderFactory',
    ]);
  });

  testWidgets('enableLogger invokes pigeon channel', (WidgetTester tester) async {
    final MockHandler mock = MockHandler();
    when(mock.call(any)).thenAnswer(
        (Invocation _) => Future<ByteData?>.value(pigeonCodec.encodeMessage(<Object?>[])));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.enableLogger', mock.call);
    await AppMetricaPush.enableLogger();
    verify(mock.call(any));
  });

  testWidgets('getLaunchPushInfo maps non-null payload via pigeon codec',
      (WidgetTester tester) async {
    const String payload = 'launch-payload';
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.getLaunchPushInfo',
        (ByteData? _) {
      return Future<ByteData?>.value(pigeonCodec.encodeMessage(<Object?>[
        AppMetricaPushInfoPigeon(payload: payload),
      ]));
    });

    final AppMetricaPushInfo info = await AppMetricaPush.getLaunchPushInfo();
    expect(info.payload, payload);
  });

  testWidgets('pushClickStream receives onPushReceived via pigeon codec',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate', stubHandler);
    await AppMetricaPush.activate();

    const String payload = 'click-payload';
    final Channel<AppMetricaPushInfo> channel = Channel<AppMetricaPushInfo>();
    AppMetricaPush.pushClickStream.listen((AppMetricaPushInfo event) => channel.send(event));

    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'dev.flutter.pigeon.appmetrica_push_plugin.PushReceiverApi.onPushReceived',
        pushReceiverCodec.encodeMessage(<Object?>[
          AppMetricaPushInfoPigeon(payload: payload),
        ]),
        (ByteData? data) {});

    expect((await channel.receive()).data!.payload, payload);
  });

  test('FirebasePushProvider.nativeFactoryClass', () {
    expect(
      FirebasePushProvider().nativeFactoryClass,
      'io.appmetrica.analytics.push.flutter.FirebasePushProviderFactory',
    );
  });
}
