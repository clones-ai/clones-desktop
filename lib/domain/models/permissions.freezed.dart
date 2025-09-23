// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PermissionsData {
  PermissionStatus get accessibilityStatus =>
      throw _privateConstructorUsedError;
  PermissionStatus get screenRecordingStatus =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of PermissionsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionsDataCopyWith<PermissionsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionsDataCopyWith<$Res> {
  factory $PermissionsDataCopyWith(
          PermissionsData value, $Res Function(PermissionsData) then) =
      _$PermissionsDataCopyWithImpl<$Res, PermissionsData>;
  @useResult
  $Res call(
      {PermissionStatus accessibilityStatus,
      PermissionStatus screenRecordingStatus,
      bool isLoading});
}

/// @nodoc
class _$PermissionsDataCopyWithImpl<$Res, $Val extends PermissionsData>
    implements $PermissionsDataCopyWith<$Res> {
  _$PermissionsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessibilityStatus = null,
    Object? screenRecordingStatus = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      accessibilityStatus: null == accessibilityStatus
          ? _value.accessibilityStatus
          : accessibilityStatus // ignore: cast_nullable_to_non_nullable
              as PermissionStatus,
      screenRecordingStatus: null == screenRecordingStatus
          ? _value.screenRecordingStatus
          : screenRecordingStatus // ignore: cast_nullable_to_non_nullable
              as PermissionStatus,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionsDataImplCopyWith<$Res>
    implements $PermissionsDataCopyWith<$Res> {
  factory _$$PermissionsDataImplCopyWith(_$PermissionsDataImpl value,
          $Res Function(_$PermissionsDataImpl) then) =
      __$$PermissionsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PermissionStatus accessibilityStatus,
      PermissionStatus screenRecordingStatus,
      bool isLoading});
}

/// @nodoc
class __$$PermissionsDataImplCopyWithImpl<$Res>
    extends _$PermissionsDataCopyWithImpl<$Res, _$PermissionsDataImpl>
    implements _$$PermissionsDataImplCopyWith<$Res> {
  __$$PermissionsDataImplCopyWithImpl(
      _$PermissionsDataImpl _value, $Res Function(_$PermissionsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessibilityStatus = null,
    Object? screenRecordingStatus = null,
    Object? isLoading = null,
  }) {
    return _then(_$PermissionsDataImpl(
      accessibilityStatus: null == accessibilityStatus
          ? _value.accessibilityStatus
          : accessibilityStatus // ignore: cast_nullable_to_non_nullable
              as PermissionStatus,
      screenRecordingStatus: null == screenRecordingStatus
          ? _value.screenRecordingStatus
          : screenRecordingStatus // ignore: cast_nullable_to_non_nullable
              as PermissionStatus,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PermissionsDataImpl extends _PermissionsData {
  const _$PermissionsDataImpl(
      {this.accessibilityStatus = PermissionStatus.unknown,
      this.screenRecordingStatus = PermissionStatus.unknown,
      this.isLoading = true})
      : super._();

  @override
  @JsonKey()
  final PermissionStatus accessibilityStatus;
  @override
  @JsonKey()
  final PermissionStatus screenRecordingStatus;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'PermissionsData(accessibilityStatus: $accessibilityStatus, screenRecordingStatus: $screenRecordingStatus, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionsDataImpl &&
            (identical(other.accessibilityStatus, accessibilityStatus) ||
                other.accessibilityStatus == accessibilityStatus) &&
            (identical(other.screenRecordingStatus, screenRecordingStatus) ||
                other.screenRecordingStatus == screenRecordingStatus) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, accessibilityStatus, screenRecordingStatus, isLoading);

  /// Create a copy of PermissionsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionsDataImplCopyWith<_$PermissionsDataImpl> get copyWith =>
      __$$PermissionsDataImplCopyWithImpl<_$PermissionsDataImpl>(
          this, _$identity);
}

abstract class _PermissionsData extends PermissionsData {
  const factory _PermissionsData(
      {final PermissionStatus accessibilityStatus,
      final PermissionStatus screenRecordingStatus,
      final bool isLoading}) = _$PermissionsDataImpl;
  const _PermissionsData._() : super._();

  @override
  PermissionStatus get accessibilityStatus;
  @override
  PermissionStatus get screenRecordingStatus;
  @override
  bool get isLoading;

  /// Create a copy of PermissionsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionsDataImplCopyWith<_$PermissionsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
