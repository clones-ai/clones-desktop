// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_modal_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateModalState {
  bool get isVisible => throw _privateConstructorUsedError;
  UpdateInfo? get updateInfo => throw _privateConstructorUsedError;
  UpdateStatus get status => throw _privateConstructorUsedError;
  int get downloadProgress => throw _privateConstructorUsedError;
  int get totalBytes => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get downloadedFilePath => throw _privateConstructorUsedError;

  /// Create a copy of UpdateModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateModalStateCopyWith<UpdateModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateModalStateCopyWith<$Res> {
  factory $UpdateModalStateCopyWith(
          UpdateModalState value, $Res Function(UpdateModalState) then) =
      _$UpdateModalStateCopyWithImpl<$Res, UpdateModalState>;
  @useResult
  $Res call(
      {bool isVisible,
      UpdateInfo? updateInfo,
      UpdateStatus status,
      int downloadProgress,
      int totalBytes,
      String? error,
      String? downloadedFilePath});

  $UpdateInfoCopyWith<$Res>? get updateInfo;
}

/// @nodoc
class _$UpdateModalStateCopyWithImpl<$Res, $Val extends UpdateModalState>
    implements $UpdateModalStateCopyWith<$Res> {
  _$UpdateModalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
    Object? updateInfo = freezed,
    Object? status = null,
    Object? downloadProgress = null,
    Object? totalBytes = null,
    Object? error = freezed,
    Object? downloadedFilePath = freezed,
  }) {
    return _then(_value.copyWith(
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      updateInfo: freezed == updateInfo
          ? _value.updateInfo
          : updateInfo // ignore: cast_nullable_to_non_nullable
              as UpdateInfo?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UpdateStatus,
      downloadProgress: null == downloadProgress
          ? _value.downloadProgress
          : downloadProgress // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadedFilePath: freezed == downloadedFilePath
          ? _value.downloadedFilePath
          : downloadedFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of UpdateModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateInfoCopyWith<$Res>? get updateInfo {
    if (_value.updateInfo == null) {
      return null;
    }

    return $UpdateInfoCopyWith<$Res>(_value.updateInfo!, (value) {
      return _then(_value.copyWith(updateInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateModalStateImplCopyWith<$Res>
    implements $UpdateModalStateCopyWith<$Res> {
  factory _$$UpdateModalStateImplCopyWith(_$UpdateModalStateImpl value,
          $Res Function(_$UpdateModalStateImpl) then) =
      __$$UpdateModalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isVisible,
      UpdateInfo? updateInfo,
      UpdateStatus status,
      int downloadProgress,
      int totalBytes,
      String? error,
      String? downloadedFilePath});

  @override
  $UpdateInfoCopyWith<$Res>? get updateInfo;
}

/// @nodoc
class __$$UpdateModalStateImplCopyWithImpl<$Res>
    extends _$UpdateModalStateCopyWithImpl<$Res, _$UpdateModalStateImpl>
    implements _$$UpdateModalStateImplCopyWith<$Res> {
  __$$UpdateModalStateImplCopyWithImpl(_$UpdateModalStateImpl _value,
      $Res Function(_$UpdateModalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
    Object? updateInfo = freezed,
    Object? status = null,
    Object? downloadProgress = null,
    Object? totalBytes = null,
    Object? error = freezed,
    Object? downloadedFilePath = freezed,
  }) {
    return _then(_$UpdateModalStateImpl(
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      updateInfo: freezed == updateInfo
          ? _value.updateInfo
          : updateInfo // ignore: cast_nullable_to_non_nullable
              as UpdateInfo?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UpdateStatus,
      downloadProgress: null == downloadProgress
          ? _value.downloadProgress
          : downloadProgress // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadedFilePath: freezed == downloadedFilePath
          ? _value.downloadedFilePath
          : downloadedFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UpdateModalStateImpl implements _UpdateModalState {
  const _$UpdateModalStateImpl(
      {this.isVisible = false,
      this.updateInfo,
      this.status = UpdateStatus.idle,
      this.downloadProgress = 0,
      this.totalBytes = 0,
      this.error,
      this.downloadedFilePath});

  @override
  @JsonKey()
  final bool isVisible;
  @override
  final UpdateInfo? updateInfo;
  @override
  @JsonKey()
  final UpdateStatus status;
  @override
  @JsonKey()
  final int downloadProgress;
  @override
  @JsonKey()
  final int totalBytes;
  @override
  final String? error;
  @override
  final String? downloadedFilePath;

  @override
  String toString() {
    return 'UpdateModalState(isVisible: $isVisible, updateInfo: $updateInfo, status: $status, downloadProgress: $downloadProgress, totalBytes: $totalBytes, error: $error, downloadedFilePath: $downloadedFilePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateModalStateImpl &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.updateInfo, updateInfo) ||
                other.updateInfo == updateInfo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.downloadProgress, downloadProgress) ||
                other.downloadProgress == downloadProgress) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.downloadedFilePath, downloadedFilePath) ||
                other.downloadedFilePath == downloadedFilePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isVisible, updateInfo, status,
      downloadProgress, totalBytes, error, downloadedFilePath);

  /// Create a copy of UpdateModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateModalStateImplCopyWith<_$UpdateModalStateImpl> get copyWith =>
      __$$UpdateModalStateImplCopyWithImpl<_$UpdateModalStateImpl>(
          this, _$identity);
}

abstract class _UpdateModalState implements UpdateModalState {
  const factory _UpdateModalState(
      {final bool isVisible,
      final UpdateInfo? updateInfo,
      final UpdateStatus status,
      final int downloadProgress,
      final int totalBytes,
      final String? error,
      final String? downloadedFilePath}) = _$UpdateModalStateImpl;

  @override
  bool get isVisible;
  @override
  UpdateInfo? get updateInfo;
  @override
  UpdateStatus get status;
  @override
  int get downloadProgress;
  @override
  int get totalBytes;
  @override
  String? get error;
  @override
  String? get downloadedFilePath;

  /// Create a copy of UpdateModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateModalStateImplCopyWith<_$UpdateModalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
