// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_manifest.freezed.dart';
part 'file_manifest.g.dart';

@freezed
class FileManifestEntry with _$FileManifestEntry {
  const factory FileManifestEntry({
    int? size,
    String? hash,
  }) = _FileManifestEntry;

  factory FileManifestEntry.fromJson(Map<String, dynamic> json) =>
      _$FileManifestEntryFromJson(json);
}

@freezed
class FileManifest with _$FileManifest {
  const factory FileManifest({
    FileManifestEntry? recording,
    FileManifestEntry? meta,
    @JsonKey(name: 'input_log') FileManifestEntry? inputLog,
    FileManifestEntry? sft,
  }) = _FileManifest;

  factory FileManifest.fromJson(Map<String, dynamic> json) =>
      _$FileManifestFromJson(json);
}