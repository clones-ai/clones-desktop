// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileManifestEntryImpl _$$FileManifestEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$FileManifestEntryImpl(
      size: (json['size'] as num?)?.toInt(),
      hash: json['hash'] as String?,
    );

Map<String, dynamic> _$$FileManifestEntryImplToJson(
        _$FileManifestEntryImpl instance) =>
    <String, dynamic>{
      'size': instance.size,
      'hash': instance.hash,
    };

_$FileManifestImpl _$$FileManifestImplFromJson(Map<String, dynamic> json) =>
    _$FileManifestImpl(
      recording: json['recording'] == null
          ? null
          : FileManifestEntry.fromJson(
              json['recording'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : FileManifestEntry.fromJson(json['meta'] as Map<String, dynamic>),
      inputLog: json['input_log'] == null
          ? null
          : FileManifestEntry.fromJson(
              json['input_log'] as Map<String, dynamic>),
      sft: json['sft'] == null
          ? null
          : FileManifestEntry.fromJson(json['sft'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FileManifestImplToJson(_$FileManifestImpl instance) =>
    <String, dynamic>{
      'recording': instance.recording,
      'meta': instance.meta,
      'input_log': instance.inputLog,
      'sft': instance.sft,
    };
