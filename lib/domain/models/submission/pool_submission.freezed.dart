// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool_submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PoolSubmission _$PoolSubmissionFromJson(Map<String, dynamic> json) {
  return _PoolSubmission.fromJson(json);
}

/// @nodoc
mixin _$PoolSubmission {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  SubmissionMeta get meta => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<SubmissionFile>? get files => throw _privateConstructorUsedError;
  @JsonKey(name: 'grade_result')
  GradeResult? get gradeResult => throw _privateConstructorUsedError;
  double? get reward => throw _privateConstructorUsedError;
  double? get maxReward => throw _privateConstructorUsedError;
  double? get clampedScore => throw _privateConstructorUsedError;
  ClaimAuthorization? get claimAuthorization =>
      throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PoolSubmission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolSubmissionCopyWith<PoolSubmission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolSubmissionCopyWith<$Res> {
  factory $PoolSubmissionCopyWith(
          PoolSubmission value, $Res Function(PoolSubmission) then) =
      _$PoolSubmissionCopyWithImpl<$Res, PoolSubmission>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String address,
      SubmissionMeta meta,
      String status,
      List<SubmissionFile>? files,
      @JsonKey(name: 'grade_result') GradeResult? gradeResult,
      double? reward,
      double? maxReward,
      double? clampedScore,
      ClaimAuthorization? claimAuthorization,
      String createdAt,
      String updatedAt});

  $SubmissionMetaCopyWith<$Res> get meta;
  $GradeResultCopyWith<$Res>? get gradeResult;
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization;
}

/// @nodoc
class _$PoolSubmissionCopyWithImpl<$Res, $Val extends PoolSubmission>
    implements $PoolSubmissionCopyWith<$Res> {
  _$PoolSubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? address = null,
    Object? meta = null,
    Object? status = null,
    Object? files = freezed,
    Object? gradeResult = freezed,
    Object? reward = freezed,
    Object? maxReward = freezed,
    Object? clampedScore = freezed,
    Object? claimAuthorization = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SubmissionMeta,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      files: freezed == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<SubmissionFile>?,
      gradeResult: freezed == gradeResult
          ? _value.gradeResult
          : gradeResult // ignore: cast_nullable_to_non_nullable
              as GradeResult?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as double?,
      maxReward: freezed == maxReward
          ? _value.maxReward
          : maxReward // ignore: cast_nullable_to_non_nullable
              as double?,
      clampedScore: freezed == clampedScore
          ? _value.clampedScore
          : clampedScore // ignore: cast_nullable_to_non_nullable
              as double?,
      claimAuthorization: freezed == claimAuthorization
          ? _value.claimAuthorization
          : claimAuthorization // ignore: cast_nullable_to_non_nullable
              as ClaimAuthorization?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubmissionMetaCopyWith<$Res> get meta {
    return $SubmissionMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeResultCopyWith<$Res>? get gradeResult {
    if (_value.gradeResult == null) {
      return null;
    }

    return $GradeResultCopyWith<$Res>(_value.gradeResult!, (value) {
      return _then(_value.copyWith(gradeResult: value) as $Val);
    });
  }

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization {
    if (_value.claimAuthorization == null) {
      return null;
    }

    return $ClaimAuthorizationCopyWith<$Res>(_value.claimAuthorization!,
        (value) {
      return _then(_value.copyWith(claimAuthorization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PoolSubmissionImplCopyWith<$Res>
    implements $PoolSubmissionCopyWith<$Res> {
  factory _$$PoolSubmissionImplCopyWith(_$PoolSubmissionImpl value,
          $Res Function(_$PoolSubmissionImpl) then) =
      __$$PoolSubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String address,
      SubmissionMeta meta,
      String status,
      List<SubmissionFile>? files,
      @JsonKey(name: 'grade_result') GradeResult? gradeResult,
      double? reward,
      double? maxReward,
      double? clampedScore,
      ClaimAuthorization? claimAuthorization,
      String createdAt,
      String updatedAt});

  @override
  $SubmissionMetaCopyWith<$Res> get meta;
  @override
  $GradeResultCopyWith<$Res>? get gradeResult;
  @override
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization;
}

/// @nodoc
class __$$PoolSubmissionImplCopyWithImpl<$Res>
    extends _$PoolSubmissionCopyWithImpl<$Res, _$PoolSubmissionImpl>
    implements _$$PoolSubmissionImplCopyWith<$Res> {
  __$$PoolSubmissionImplCopyWithImpl(
      _$PoolSubmissionImpl _value, $Res Function(_$PoolSubmissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? address = null,
    Object? meta = null,
    Object? status = null,
    Object? files = freezed,
    Object? gradeResult = freezed,
    Object? reward = freezed,
    Object? maxReward = freezed,
    Object? clampedScore = freezed,
    Object? claimAuthorization = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PoolSubmissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SubmissionMeta,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      files: freezed == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<SubmissionFile>?,
      gradeResult: freezed == gradeResult
          ? _value.gradeResult
          : gradeResult // ignore: cast_nullable_to_non_nullable
              as GradeResult?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as double?,
      maxReward: freezed == maxReward
          ? _value.maxReward
          : maxReward // ignore: cast_nullable_to_non_nullable
              as double?,
      clampedScore: freezed == clampedScore
          ? _value.clampedScore
          : clampedScore // ignore: cast_nullable_to_non_nullable
              as double?,
      claimAuthorization: freezed == claimAuthorization
          ? _value.claimAuthorization
          : claimAuthorization // ignore: cast_nullable_to_non_nullable
              as ClaimAuthorization?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolSubmissionImpl implements _PoolSubmission {
  const _$PoolSubmissionImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.address,
      required this.meta,
      required this.status,
      final List<SubmissionFile>? files,
      @JsonKey(name: 'grade_result') this.gradeResult,
      this.reward,
      this.maxReward,
      this.clampedScore,
      this.claimAuthorization,
      required this.createdAt,
      required this.updatedAt})
      : _files = files;

  factory _$PoolSubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolSubmissionImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String address;
  @override
  final SubmissionMeta meta;
  @override
  final String status;
  final List<SubmissionFile>? _files;
  @override
  List<SubmissionFile>? get files {
    final value = _files;
    if (value == null) return null;
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'grade_result')
  final GradeResult? gradeResult;
  @override
  final double? reward;
  @override
  final double? maxReward;
  @override
  final double? clampedScore;
  @override
  final ClaimAuthorization? claimAuthorization;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'PoolSubmission(id: $id, address: $address, meta: $meta, status: $status, files: $files, gradeResult: $gradeResult, reward: $reward, maxReward: $maxReward, clampedScore: $clampedScore, claimAuthorization: $claimAuthorization, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolSubmissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.gradeResult, gradeResult) ||
                other.gradeResult == gradeResult) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.maxReward, maxReward) ||
                other.maxReward == maxReward) &&
            (identical(other.clampedScore, clampedScore) ||
                other.clampedScore == clampedScore) &&
            (identical(other.claimAuthorization, claimAuthorization) ||
                other.claimAuthorization == claimAuthorization) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      address,
      meta,
      status,
      const DeepCollectionEquality().hash(_files),
      gradeResult,
      reward,
      maxReward,
      clampedScore,
      claimAuthorization,
      createdAt,
      updatedAt);

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolSubmissionImplCopyWith<_$PoolSubmissionImpl> get copyWith =>
      __$$PoolSubmissionImplCopyWithImpl<_$PoolSubmissionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolSubmissionImplToJson(
      this,
    );
  }
}

abstract class _PoolSubmission implements PoolSubmission {
  const factory _PoolSubmission(
      {@JsonKey(name: '_id') required final String id,
      required final String address,
      required final SubmissionMeta meta,
      required final String status,
      final List<SubmissionFile>? files,
      @JsonKey(name: 'grade_result') final GradeResult? gradeResult,
      final double? reward,
      final double? maxReward,
      final double? clampedScore,
      final ClaimAuthorization? claimAuthorization,
      required final String createdAt,
      required final String updatedAt}) = _$PoolSubmissionImpl;

  factory _PoolSubmission.fromJson(Map<String, dynamic> json) =
      _$PoolSubmissionImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get address;
  @override
  SubmissionMeta get meta;
  @override
  String get status;
  @override
  List<SubmissionFile>? get files;
  @override
  @JsonKey(name: 'grade_result')
  GradeResult? get gradeResult;
  @override
  double? get reward;
  @override
  double? get maxReward;
  @override
  double? get clampedScore;
  @override
  ClaimAuthorization? get claimAuthorization;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of PoolSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolSubmissionImplCopyWith<_$PoolSubmissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
