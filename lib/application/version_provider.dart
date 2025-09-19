import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaml/yaml.dart';

part 'version_provider.g.dart';

@riverpod
Future<String> appVersion(Ref ref) async {
  final pubspecString = await rootBundle.loadString('pubspec.yaml');
  final doc = loadYaml(pubspecString);
  if (doc is YamlMap && doc.containsKey('version')) {
    final version = doc['version'] as String;
    return version.split('+').first;
  }
  throw Exception('Version not found in pubspec.yaml');
}
