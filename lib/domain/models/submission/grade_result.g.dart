// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradeResultImpl _$$GradeResultImplFromJson(Map<String, dynamic> json) =>
    _$GradeResultImpl(
      summary: json['summary'] as String,
      score: (json['score'] as num).toInt(),
      reasoning: json['reasoning'] as String,
      scratchpad: json['scratchpad'] as String?,
      id: json['_id'] as String,
      version: json['version'] as String?,
      observations: json['observations'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      outcomeAchievement: (json['outcomeAchievement'] as num?)?.toDouble(),
      processQuality: (json['processQuality'] as num?)?.toDouble(),
      efficiency: (json['efficiency'] as num?)?.toDouble(),
      confidenceReasoning: json['confidenceReasoning'] as String?,
      outcomeAchievementReasoning:
          json['outcomeAchievementReasoning'] as String?,
      processQualityReasoning: json['processQualityReasoning'] as String?,
      efficiencyReasoning: json['efficiencyReasoning'] as String?,
      programmaticResults: json['programmaticResults'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$GradeResultImplToJson(_$GradeResultImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'score': instance.score,
      'reasoning': instance.reasoning,
      'scratchpad': instance.scratchpad,
      '_id': instance.id,
      'version': instance.version,
      'observations': instance.observations,
      'confidence': instance.confidence,
      'outcomeAchievement': instance.outcomeAchievement,
      'processQuality': instance.processQuality,
      'efficiency': instance.efficiency,
      'confidenceReasoning': instance.confidenceReasoning,
      'outcomeAchievementReasoning': instance.outcomeAchievementReasoning,
      'processQualityReasoning': instance.processQualityReasoning,
      'efficiencyReasoning': instance.efficiencyReasoning,
      'programmaticResults': instance.programmaticResults,
    };
