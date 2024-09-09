#!/bin/bash
mkdir -p ios/AppMetricaPushPlugin/
mkdir -p android/src/main/java/io/appmetrica/analytics/push/flutter/pigeon
flutter pub run pigeon --input pigeons/appmetrica_push_api.dart 
