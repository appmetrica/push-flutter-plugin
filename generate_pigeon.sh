#!/bin/bash
mkdir -p ios/AppMetricaPushPlugin/
mkdir -p android/src/main/java/io/appmetrica/analytics/push/flutter/pigeon
flutter pub run pigeon \
  --input pigeons/appmetrica_push_api.dart \
  --dart_out lib/src/appmetrica_push_api_pigeon.dart \
  --objc_prefix AMPF \
  --objc_header_out ios/AppMetricaPushPlugin/AMPFPigeon.h \
  --objc_source_out ios/AppMetricaPushPlugin/AMPFPigeon.m \
  --java_out android/src/main/java/io/appmetrica/analytics/push/flutter/pigeon/Pigeon.java \
  --java_package "io.appmetrica.analytics.push.flutter.pigeon"
