import 'dart:convert';

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
