
import 'package:flutter/material.dart';
import 'package:appmetrica_push_plugin/appmetrica_push_plugin.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

AppMetricaConfig get _config =>
    const AppMetricaConfig('Your api key', logs: true);

Future<void> main() async {
  AppMetrica.runZoneGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppMetrica.activate(_config);
    AppMetricaPush.activate();
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AppMetrica Push plugin example app'),
        ),
        body: Builder(
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListView(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    AppMetricaPush.requestPermission(
                        alert: true, badge: true, sound: true);
                  },
                  child: const Text('Request permissons'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppMetricaPush.tokenStream.listen((tokens) {
                      _showSnackBar(context, 'Tokens update: $tokens');
                    });
                  },
                  child: const Text('Start token listening'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final tokens = await AppMetricaPush.getTokens();
                    _showSnackBar(context, 'Tokens: $tokens');
                  },
                  child: const Text('Request tokens'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String content) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
