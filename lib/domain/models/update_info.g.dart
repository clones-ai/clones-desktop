// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateInfoImpl _$$UpdateInfoImplFromJson(Map<String, dynamic> json) =>
    _$UpdateInfoImpl(
      version: json['version'] as String,
      currentVersion: json['currentVersion'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      files: (json['files'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, UpdateFile.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$UpdateInfoImplToJson(_$UpdateInfoImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'currentVersion': instance.currentVersion,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'files': instance.files,
    };

_$UpdateFileImpl _$$UpdateFileImplFromJson(Map<String, dynamic> json) =>
    _$UpdateFileImpl(
      filename: json['filename'] as String,
      url: json['url'] as String,
      size: (json['size'] as num).toInt(),
      arch: json['arch'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$UpdateFileImplToJson(_$UpdateFileImpl instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'url': instance.url,
      'size': instance.size,
      'arch': instance.arch,
      'type': instance.type,
    };
