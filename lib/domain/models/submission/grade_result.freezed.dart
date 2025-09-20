// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GradeResult _$GradeResultFromJson(Map<String, dynamic> json) {
  return _GradeResult.fromJson(json);
}

/// @nodoc
mixin _$GradeResult {
  String get summary => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  String? get scratchpad => throw _privateConstructorUsedError;
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  String? get observations => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  double? get outcomeAchievement => throw _privateConstructorUsedError;
  double? get processQuality => throw _privateConstructorUsedError;
  double? get efficiency => throw _privateConstructorUsedError;
  String? get confidenceReasoning => throw _privateConstructorUsedError;
  String? get outcomeAchievementReasoning => throw _privateConstructorUsedError;
  String? get processQualityReasoning => throw _privateConstructorUsedError;
  String? get efficiencyReasoning => throw _privateConstructorUsedError;
  Map<String, dynamic>? get programmaticResults =>
      throw _privateConstructorUsedError;

  /// Serializes this GradeResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GradeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeResultCopyWith<GradeResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeResultCopyWith<$Res> {
  factory $GradeResultCopyWith(
          GradeResult value, $Res Function(GradeResult) then) =
      _$GradeResultCopyWithImpl<$Res, GradeResult>;
  @useResult
  $Res call(
      {String summary,
      int score,
      String reasoning,
      String? scratchpad,
      @JsonKey(name: '_id') String id,
      String? version,
      String? observations,
      double? confidence,
      double? outcomeAchievement,
      double? processQuality,
      double? efficiency,
      String? confidenceReasoning,
      String? outcomeAchievementReasoning,
      String? processQualityReasoning,
      String? efficiencyReasoning,
      Map<String, dynamic>? programmaticResults});
}

/// @nodoc
class _$GradeResultCopyWithImpl<$Res, $Val extends GradeResult>
    implements $GradeResultCopyWith<$Res> {
  _$GradeResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GradeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? score = null,
    Object? reasoning = null,
    Object? scratchpad = freezed,
    Object? id = null,
    Object? version = freezed,
    Object? observations = freezed,
    Object? confidence = freezed,
    Object? outcomeAchievement = freezed,
    Object? processQuality = freezed,
    Object? efficiency = freezed,
    Object? confidenceReasoning = freezed,
    Object? outcomeAchievementReasoning = freezed,
    Object? processQualityReasoning = freezed,
    Object? efficiencyReasoning = freezed,
    Object? programmaticResults = freezed,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      scratchpad: freezed == scratchpad
          ? _value.scratchpad
          : scratchpad // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      observations: freezed == observations
          ? _value.observations
          : observations // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      outcomeAchievement: freezed == outcomeAchievement
          ? _value.outcomeAchievement
          : outcomeAchievement // ignore: cast_nullable_to_non_nullable
              as double?,
      processQuality: freezed == processQuality
          ? _value.processQuality
          : processQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      efficiency: freezed == efficiency
          ? _value.efficiency
          : efficiency // ignore: cast_nullable_to_non_nullable
              as double?,
      confidenceReasoning: freezed == confidenceReasoning
          ? _value.confidenceReasoning
          : confidenceReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      outcomeAchievementReasoning: freezed == outcomeAchievementReasoning
          ? _value.outcomeAchievementReasoning
          : outcomeAchievementReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      processQualityReasoning: freezed == processQualityReasoning
          ? _value.processQualityReasoning
          : processQualityReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      efficiencyReasoning: freezed == efficiencyReasoning
          ? _value.efficiencyReasoning
          : efficiencyReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      programmaticResults: freezed == programmaticResults
          ? _value.programmaticResults
          : programmaticResults // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GradeResultImplCopyWith<$Res>
    implements $GradeResultCopyWith<$Res> {
  factory _$$GradeResultImplCopyWith(
          _$GradeResultImpl value, $Res Function(_$GradeResultImpl) then) =
      __$$GradeResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary,
      int score,
      String reasoning,
      String? scratchpad,
      @JsonKey(name: '_id') String id,
      String? version,
      String? observations,
      double? confidence,
      double? outcomeAchievement,
      double? processQuality,
      double? efficiency,
      String? confidenceReasoning,
      String? outcomeAchievementReasoning,
      String? processQualityReasoning,
      String? efficiencyReasoning,
      Map<String, dynamic>? programmaticResults});
}

/// @nodoc
class __$$GradeResultImplCopyWithImpl<$Res>
    extends _$GradeResultCopyWithImpl<$Res, _$GradeResultImpl>
    implements _$$GradeResultImplCopyWith<$Res> {
  __$$GradeResultImplCopyWithImpl(
      _$GradeResultImpl _value, $Res Function(_$GradeResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of GradeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? score = null,
    Object? reasoning = null,
    Object? scratchpad = freezed,
    Object? id = null,
    Object? version = freezed,
    Object? observations = freezed,
    Object? confidence = freezed,
    Object? outcomeAchievement = freezed,
    Object? processQuality = freezed,
    Object? efficiency = freezed,
    Object? confidenceReasoning = freezed,
    Object? outcomeAchievementReasoning = freezed,
    Object? processQualityReasoning = freezed,
    Object? efficiencyReasoning = freezed,
    Object? programmaticResults = freezed,
  }) {
    return _then(_$GradeResultImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      scratchpad: freezed == scratchpad
          ? _value.scratchpad
          : scratchpad // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      observations: freezed == observations
          ? _value.observations
          : observations // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      outcomeAchievement: freezed == outcomeAchievement
          ? _value.outcomeAchievement
          : outcomeAchievement // ignore: cast_nullable_to_non_nullable
              as double?,
      processQuality: freezed == processQuality
          ? _value.processQuality
          : processQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      efficiency: freezed == efficiency
          ? _value.efficiency
          : efficiency // ignore: cast_nullable_to_non_nullable
              as double?,
      confidenceReasoning: freezed == confidenceReasoning
          ? _value.confidenceReasoning
          : confidenceReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      outcomeAchievementReasoning: freezed == outcomeAchievementReasoning
          ? _value.outcomeAchievementReasoning
          : outcomeAchievementReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      processQualityReasoning: freezed == processQualityReasoning
          ? _value.processQualityReasoning
          : processQualityReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      efficiencyReasoning: freezed == efficiencyReasoning
          ? _value.efficiencyReasoning
          : efficiencyReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      programmaticResults: freezed == programmaticResults
          ? _value._programmaticResults
          : programmaticResults // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GradeResultImpl implements _GradeResult {
  const _$GradeResultImpl(
      {required this.summary,
      required this.score,
      required this.reasoning,
      this.scratchpad,
      @JsonKey(name: '_id') required this.id,
      this.version,
      this.observations,
      this.confidence,
      this.outcomeAchievement,
      this.processQuality,
      this.efficiency,
      this.confidenceReasoning,
      this.outcomeAchievementReasoning,
      this.processQualityReasoning,
      this.efficiencyReasoning,
      final Map<String, dynamic>? programmaticResults})
      : _programmaticResults = programmaticResults;

  factory _$GradeResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradeResultImplFromJson(json);

  @override
  final String summary;
  @override
  final int score;
  @override
  final String reasoning;
  @override
  final String? scratchpad;
  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String? version;
  @override
  final String? observations;
  @override
  final double? confidence;
  @override
  final double? outcomeAchievement;
  @override
  final double? processQuality;
  @override
  final double? efficiency;
  @override
  final String? confidenceReasoning;
  @override
  final String? outcomeAchievementReasoning;
  @override
  final String? processQualityReasoning;
  @override
  final String? efficiencyReasoning;
  final Map<String, dynamic>? _programmaticResults;
  @override
  Map<String, dynamic>? get programmaticResults {
    final value = _programmaticResults;
    if (value == null) return null;
    if (_programmaticResults is EqualUnmodifiableMapView)
      return _programmaticResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GradeResult(summary: $summary, score: $score, reasoning: $reasoning, scratchpad: $scratchpad, id: $id, version: $version, observations: $observations, confidence: $confidence, outcomeAchievement: $outcomeAchievement, processQuality: $processQuality, efficiency: $efficiency, confidenceReasoning: $confidenceReasoning, outcomeAchievementReasoning: $outcomeAchievementReasoning, processQualityReasoning: $processQualityReasoning, efficiencyReasoning: $efficiencyReasoning, programmaticResults: $programmaticResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeResultImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            (identical(other.scratchpad, scratchpad) ||
                other.scratchpad == scratchpad) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.observations, observations) ||
                other.observations == observations) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.outcomeAchievement, outcomeAchievement) ||
                other.outcomeAchievement == outcomeAchievement) &&
            (identical(other.processQuality, processQuality) ||
                other.processQuality == processQuality) &&
            (identical(other.efficiency, efficiency) ||
                other.efficiency == efficiency) &&
            (identical(other.confidenceReasoning, confidenceReasoning) ||
                other.confidenceReasoning == confidenceReasoning) &&
            (identical(other.outcomeAchievementReasoning,
                    outcomeAchievementReasoning) ||
                other.outcomeAchievementReasoning ==
                    outcomeAchievementReasoning) &&
            (identical(
                    other.processQualityReasoning, processQualityReasoning) ||
                other.processQualityReasoning == processQualityReasoning) &&
            (identical(other.efficiencyReasoning, efficiencyReasoning) ||
                other.efficiencyReasoning == efficiencyReasoning) &&
            const DeepCollectionEquality()
                .equals(other._programmaticResults, _programmaticResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      score,
      reasoning,
      scratchpad,
      id,
      version,
      observations,
      confidence,
      outcomeAchievement,
      processQuality,
      efficiency,
      confidenceReasoning,
      outcomeAchievementReasoning,
      processQualityReasoning,
      efficiencyReasoning,
      const DeepCollectionEquality().hash(_programmaticResults));

  /// Create a copy of GradeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeResultImplCopyWith<_$GradeResultImpl> get copyWith =>
      __$$GradeResultImplCopyWithImpl<_$GradeResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradeResultImplToJson(
      this,
    );
  }
}

abstract class _GradeResult implements GradeResult {
  const factory _GradeResult(
      {required final String summary,
      required final int score,
      required final String reasoning,
      final String? scratchpad,
      @JsonKey(name: '_id') required final String id,
      final String? version,
      final String? observations,
      final double? confidence,
      final double? outcomeAchievement,
      final double? processQuality,
      final double? efficiency,
      final String? confidenceReasoning,
      final String? outcomeAchievementReasoning,
      final String? processQualityReasoning,
      final String? efficiencyReasoning,
      final Map<String, dynamic>? programmaticResults}) = _$GradeResultImpl;

  factory _GradeResult.fromJson(Map<String, dynamic> json) =
      _$GradeResultImpl.fromJson;

  @override
  String get summary;
  @override
  int get score;
  @override
  String get reasoning;
  @override
  String? get scratchpad;
  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String? get version;
  @override
  String? get observations;
  @override
  double? get confidence;
  @override
  double? get outcomeAchievement;
  @override
  double? get processQuality;
  @override
  double? get efficiency;
  @override
  String? get confidenceReasoning;
  @override
  String? get outcomeAchievementReasoning;
  @override
  String? get processQualityReasoning;
  @override
  String? get efficiencyReasoning;
  @override
  Map<String, dynamic>? get programmaticResults;

  /// Create a copy of GradeResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeResultImplCopyWith<_$GradeResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
