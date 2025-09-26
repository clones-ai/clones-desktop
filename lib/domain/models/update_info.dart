import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_info.freezed.dart';
part 'update_info.g.dart';

@freezed
class UpdateInfo with _$UpdateInfo {
  const factory UpdateInfo({
    required String version,
    required String currentVersion,
    required DateTime uploadDate,
    required Map<String, UpdateFile> files,
  }) = _UpdateInfo;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$UpdateInfoFromJson(json);
}

extension UpdateInfoExtension on UpdateInfo {
  bool get hasUpdate => version != currentVersion;
}

@freezed
class UpdateFile with _$UpdateFile {
  const factory UpdateFile({
    required String filename,
    required String url,
    required int size,
    required String arch,
    required String type,
  }) = _UpdateFile;

  factory UpdateFile.fromJson(Map<String, dynamic> json) =>
      _$UpdateFileFromJson(json);
}
