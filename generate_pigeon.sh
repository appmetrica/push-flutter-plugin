#!/bin/bash

set -e

mkdir -p android/src/main/java/io/appmetrica/analytics/push/flutter/pigeon
"${1:-dart}" run pigeon --input pigeons/appmetrica_push_api.dart
