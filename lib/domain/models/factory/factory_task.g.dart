// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactoryTaskImpl _$$FactoryTaskImplFromJson(Map<String, dynamic> json) =>
    _$FactoryTaskImpl(
      id: json['id'] as String?,
      prompt: json['prompt'] as String,
      uploadLimit: (json['uploadLimit'] as num?)?.toInt(),
      rewardLimit: (json['rewardLimit'] as num?)?.toDouble(),
      limitReason: json['limitReason'] as String?,
    );

Map<String, dynamic> _$$FactoryTaskImplToJson(_$FactoryTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt': instance.prompt,
      'uploadLimit': instance.uploadLimit,
      'rewardLimit': instance.rewardLimit,
      'limitReason': instance.limitReason,
    };
