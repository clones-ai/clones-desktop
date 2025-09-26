// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateInfo _$UpdateInfoFromJson(Map<String, dynamic> json) {
  return _UpdateInfo.fromJson(json);
}

/// @nodoc
mixin _$UpdateInfo {
  String get version => throw _privateConstructorUsedError;
  String get currentVersion => throw _privateConstructorUsedError;
  DateTime get uploadDate => throw _privateConstructorUsedError;
  Map<String, UpdateFile> get files => throw _privateConstructorUsedError;

  /// Serializes this UpdateInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateInfoCopyWith<UpdateInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateInfoCopyWith<$Res> {
  factory $UpdateInfoCopyWith(
          UpdateInfo value, $Res Function(UpdateInfo) then) =
      _$UpdateInfoCopyWithImpl<$Res, UpdateInfo>;
  @useResult
  $Res call(
      {String version,
      String currentVersion,
      DateTime uploadDate,
      Map<String, UpdateFile> files});
}

/// @nodoc
class _$UpdateInfoCopyWithImpl<$Res, $Val extends UpdateInfo>
    implements $UpdateInfoCopyWith<$Res> {
  _$UpdateInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? currentVersion = null,
    Object? uploadDate = null,
    Object? files = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      currentVersion: null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: null == uploadDate
          ? _value.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as Map<String, UpdateFile>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateInfoImplCopyWith<$Res>
    implements $UpdateInfoCopyWith<$Res> {
  factory _$$UpdateInfoImplCopyWith(
          _$UpdateInfoImpl value, $Res Function(_$UpdateInfoImpl) then) =
      __$$UpdateInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      String currentVersion,
      DateTime uploadDate,
      Map<String, UpdateFile> files});
}

/// @nodoc
class __$$UpdateInfoImplCopyWithImpl<$Res>
    extends _$UpdateInfoCopyWithImpl<$Res, _$UpdateInfoImpl>
    implements _$$UpdateInfoImplCopyWith<$Res> {
  __$$UpdateInfoImplCopyWithImpl(
      _$UpdateInfoImpl _value, $Res Function(_$UpdateInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? currentVersion = null,
    Object? uploadDate = null,
    Object? files = null,
  }) {
    return _then(_$UpdateInfoImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      currentVersion: null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: null == uploadDate
          ? _value.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as Map<String, UpdateFile>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateInfoImpl implements _UpdateInfo {
  const _$UpdateInfoImpl(
      {required this.version,
      required this.currentVersion,
      required this.uploadDate,
      required final Map<String, UpdateFile> files})
      : _files = files;

  factory _$UpdateInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateInfoImplFromJson(json);

  @override
  final String version;
  @override
  final String currentVersion;
  @override
  final DateTime uploadDate;
  final Map<String, UpdateFile> _files;
  @override
  Map<String, UpdateFile> get files {
    if (_files is EqualUnmodifiableMapView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_files);
  }

  @override
  String toString() {
    return 'UpdateInfo(version: $version, currentVersion: $currentVersion, uploadDate: $uploadDate, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateInfoImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.uploadDate, uploadDate) ||
                other.uploadDate == uploadDate) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, currentVersion,
      uploadDate, const DeepCollectionEquality().hash(_files));

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateInfoImplCopyWith<_$UpdateInfoImpl> get copyWith =>
      __$$UpdateInfoImplCopyWithImpl<_$UpdateInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateInfoImplToJson(
      this,
    );
  }
}

abstract class _UpdateInfo implements UpdateInfo {
  const factory _UpdateInfo(
      {required final String version,
      required final String currentVersion,
      required final DateTime uploadDate,
      required final Map<String, UpdateFile> files}) = _$UpdateInfoImpl;

  factory _UpdateInfo.fromJson(Map<String, dynamic> json) =
      _$UpdateInfoImpl.fromJson;

  @override
  String get version;
  @override
  String get currentVersion;
  @override
  DateTime get uploadDate;
  @override
  Map<String, UpdateFile> get files;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateInfoImplCopyWith<_$UpdateInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateFile _$UpdateFileFromJson(Map<String, dynamic> json) {
  return _UpdateFile.fromJson(json);
}

/// @nodoc
mixin _$UpdateFile {
  String get filename => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String get arch => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this UpdateFile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateFileCopyWith<UpdateFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateFileCopyWith<$Res> {
  factory $UpdateFileCopyWith(
          UpdateFile value, $Res Function(UpdateFile) then) =
      _$UpdateFileCopyWithImpl<$Res, UpdateFile>;
  @useResult
  $Res call({String filename, String url, int size, String arch, String type});
}

/// @nodoc
class _$UpdateFileCopyWithImpl<$Res, $Val extends UpdateFile>
    implements $UpdateFileCopyWith<$Res> {
  _$UpdateFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? url = null,
    Object? size = null,
    Object? arch = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      arch: null == arch
          ? _value.arch
          : arch // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateFileImplCopyWith<$Res>
    implements $UpdateFileCopyWith<$Res> {
  factory _$$UpdateFileImplCopyWith(
          _$UpdateFileImpl value, $Res Function(_$UpdateFileImpl) then) =
      __$$UpdateFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String filename, String url, int size, String arch, String type});
}

/// @nodoc
class __$$UpdateFileImplCopyWithImpl<$Res>
    extends _$UpdateFileCopyWithImpl<$Res, _$UpdateFileImpl>
    implements _$$UpdateFileImplCopyWith<$Res> {
  __$$UpdateFileImplCopyWithImpl(
      _$UpdateFileImpl _value, $Res Function(_$UpdateFileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? url = null,
    Object? size = null,
    Object? arch = null,
    Object? type = null,
  }) {
    return _then(_$UpdateFileImpl(
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      arch: null == arch
          ? _value.arch
          : arch // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateFileImpl implements _UpdateFile {
  const _$UpdateFileImpl(
      {required this.filename,
      required this.url,
      required this.size,
      required this.arch,
      required this.type});

  factory _$UpdateFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateFileImplFromJson(json);

  @override
  final String filename;
  @override
  final String url;
  @override
  final int size;
  @override
  final String arch;
  @override
  final String type;

  @override
  String toString() {
    return 'UpdateFile(filename: $filename, url: $url, size: $size, arch: $arch, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateFileImpl &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.arch, arch) || other.arch == arch) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, filename, url, size, arch, type);

  /// Create a copy of UpdateFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateFileImplCopyWith<_$UpdateFileImpl> get copyWith =>
      __$$UpdateFileImplCopyWithImpl<_$UpdateFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateFileImplToJson(
      this,
    );
  }
}

abstract class _UpdateFile implements UpdateFile {
  const factory _UpdateFile(
      {required final String filename,
      required final String url,
      required final int size,
      required final String arch,
      required final String type}) = _$UpdateFileImpl;

  factory _UpdateFile.fromJson(Map<String, dynamic> json) =
      _$UpdateFileImpl.fromJson;

  @override
  String get filename;
  @override
  String get url;
  @override
  int get size;
  @override
  String get arch;
  @override
  String get type;

  /// Create a copy of UpdateFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateFileImplCopyWith<_$UpdateFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
