import 'dart:convert';
import 'package:flutter/services.dart';

sealed class VideoSource {
  const VideoSource();
}

class AssetVideoSource extends VideoSource {
  const AssetVideoSource(this.path);
  final String path;
}

class FileVideoSource extends VideoSource {
  const FileVideoSource(this.path);
  final String path;
}

class Base64VideoSource extends VideoSource {
  const Base64VideoSource(this.dataUri);
  final String dataUri;

  static Future<Base64VideoSource> fromAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final base64String = base64Encode(bytes);
    final dataUri = 'data:video/mp4;base64,$base64String';
    return Base64VideoSource(dataUri);
  }

  List<int> get videoBytes {
    if (!dataUri.startsWith('data:video/mp4;base64,')) {
      throw ArgumentError('Invalid data URI format');
    }
    final parts = dataUri.split(',');
    if (parts.length != 2) {
      throw ArgumentError('Invalid data URI format');
    }
    final base64String = parts[1];
    return base64Decode(base64String);
  }
}
