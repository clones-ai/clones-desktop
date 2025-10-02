// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileManifestEntry _$FileManifestEntryFromJson(Map<String, dynamic> json) {
  return _FileManifestEntry.fromJson(json);
}

/// @nodoc
mixin _$FileManifestEntry {
  int? get size => throw _privateConstructorUsedError;
  String? get hash => throw _privateConstructorUsedError;

  /// Serializes this FileManifestEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileManifestEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileManifestEntryCopyWith<FileManifestEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileManifestEntryCopyWith<$Res> {
  factory $FileManifestEntryCopyWith(
          FileManifestEntry value, $Res Function(FileManifestEntry) then) =
      _$FileManifestEntryCopyWithImpl<$Res, FileManifestEntry>;
  @useResult
  $Res call({int? size, String? hash});
}

/// @nodoc
class _$FileManifestEntryCopyWithImpl<$Res, $Val extends FileManifestEntry>
    implements $FileManifestEntryCopyWith<$Res> {
  _$FileManifestEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileManifestEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = freezed,
    Object? hash = freezed,
  }) {
    return _then(_value.copyWith(
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileManifestEntryImplCopyWith<$Res>
    implements $FileManifestEntryCopyWith<$Res> {
  factory _$$FileManifestEntryImplCopyWith(_$FileManifestEntryImpl value,
          $Res Function(_$FileManifestEntryImpl) then) =
      __$$FileManifestEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? size, String? hash});
}

/// @nodoc
class __$$FileManifestEntryImplCopyWithImpl<$Res>
    extends _$FileManifestEntryCopyWithImpl<$Res, _$FileManifestEntryImpl>
    implements _$$FileManifestEntryImplCopyWith<$Res> {
  __$$FileManifestEntryImplCopyWithImpl(_$FileManifestEntryImpl _value,
      $Res Function(_$FileManifestEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileManifestEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = freezed,
    Object? hash = freezed,
  }) {
    return _then(_$FileManifestEntryImpl(
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileManifestEntryImpl implements _FileManifestEntry {
  const _$FileManifestEntryImpl({this.size, this.hash});

  factory _$FileManifestEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileManifestEntryImplFromJson(json);

  @override
  final int? size;
  @override
  final String? hash;

  @override
  String toString() {
    return 'FileManifestEntry(size: $size, hash: $hash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileManifestEntryImpl &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hash, hash) || other.hash == hash));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, size, hash);

  /// Create a copy of FileManifestEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileManifestEntryImplCopyWith<_$FileManifestEntryImpl> get copyWith =>
      __$$FileManifestEntryImplCopyWithImpl<_$FileManifestEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileManifestEntryImplToJson(
      this,
    );
  }
}

abstract class _FileManifestEntry implements FileManifestEntry {
  const factory _FileManifestEntry({final int? size, final String? hash}) =
      _$FileManifestEntryImpl;

  factory _FileManifestEntry.fromJson(Map<String, dynamic> json) =
      _$FileManifestEntryImpl.fromJson;

  @override
  int? get size;
  @override
  String? get hash;

  /// Create a copy of FileManifestEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileManifestEntryImplCopyWith<_$FileManifestEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FileManifest _$FileManifestFromJson(Map<String, dynamic> json) {
  return _FileManifest.fromJson(json);
}

/// @nodoc
mixin _$FileManifest {
  FileManifestEntry? get recording => throw _privateConstructorUsedError;
  FileManifestEntry? get meta => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_log')
  FileManifestEntry? get inputLog => throw _privateConstructorUsedError;
  FileManifestEntry? get sft => throw _privateConstructorUsedError;

  /// Serializes this FileManifest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileManifestCopyWith<FileManifest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileManifestCopyWith<$Res> {
  factory $FileManifestCopyWith(
          FileManifest value, $Res Function(FileManifest) then) =
      _$FileManifestCopyWithImpl<$Res, FileManifest>;
  @useResult
  $Res call(
      {FileManifestEntry? recording,
      FileManifestEntry? meta,
      @JsonKey(name: 'input_log') FileManifestEntry? inputLog,
      FileManifestEntry? sft});

  $FileManifestEntryCopyWith<$Res>? get recording;
  $FileManifestEntryCopyWith<$Res>? get meta;
  $FileManifestEntryCopyWith<$Res>? get inputLog;
  $FileManifestEntryCopyWith<$Res>? get sft;
}

/// @nodoc
class _$FileManifestCopyWithImpl<$Res, $Val extends FileManifest>
    implements $FileManifestCopyWith<$Res> {
  _$FileManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recording = freezed,
    Object? meta = freezed,
    Object? inputLog = freezed,
    Object? sft = freezed,
  }) {
    return _then(_value.copyWith(
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
      inputLog: freezed == inputLog
          ? _value.inputLog
          : inputLog // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
      sft: freezed == sft
          ? _value.sft
          : sft // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
    ) as $Val);
  }

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileManifestEntryCopyWith<$Res>? get recording {
    if (_value.recording == null) {
      return null;
    }

    return $FileManifestEntryCopyWith<$Res>(_value.recording!, (value) {
      return _then(_value.copyWith(recording: value) as $Val);
    });
  }

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileManifestEntryCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $FileManifestEntryCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileManifestEntryCopyWith<$Res>? get inputLog {
    if (_value.inputLog == null) {
      return null;
    }

    return $FileManifestEntryCopyWith<$Res>(_value.inputLog!, (value) {
      return _then(_value.copyWith(inputLog: value) as $Val);
    });
  }

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileManifestEntryCopyWith<$Res>? get sft {
    if (_value.sft == null) {
      return null;
    }

    return $FileManifestEntryCopyWith<$Res>(_value.sft!, (value) {
      return _then(_value.copyWith(sft: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FileManifestImplCopyWith<$Res>
    implements $FileManifestCopyWith<$Res> {
  factory _$$FileManifestImplCopyWith(
          _$FileManifestImpl value, $Res Function(_$FileManifestImpl) then) =
      __$$FileManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FileManifestEntry? recording,
      FileManifestEntry? meta,
      @JsonKey(name: 'input_log') FileManifestEntry? inputLog,
      FileManifestEntry? sft});

  @override
  $FileManifestEntryCopyWith<$Res>? get recording;
  @override
  $FileManifestEntryCopyWith<$Res>? get meta;
  @override
  $FileManifestEntryCopyWith<$Res>? get inputLog;
  @override
  $FileManifestEntryCopyWith<$Res>? get sft;
}

/// @nodoc
class __$$FileManifestImplCopyWithImpl<$Res>
    extends _$FileManifestCopyWithImpl<$Res, _$FileManifestImpl>
    implements _$$FileManifestImplCopyWith<$Res> {
  __$$FileManifestImplCopyWithImpl(
      _$FileManifestImpl _value, $Res Function(_$FileManifestImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recording = freezed,
    Object? meta = freezed,
    Object? inputLog = freezed,
    Object? sft = freezed,
  }) {
    return _then(_$FileManifestImpl(
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
      inputLog: freezed == inputLog
          ? _value.inputLog
          : inputLog // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
      sft: freezed == sft
          ? _value.sft
          : sft // ignore: cast_nullable_to_non_nullable
              as FileManifestEntry?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileManifestImpl implements _FileManifest {
  const _$FileManifestImpl(
      {this.recording,
      this.meta,
      @JsonKey(name: 'input_log') this.inputLog,
      this.sft});

  factory _$FileManifestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileManifestImplFromJson(json);

  @override
  final FileManifestEntry? recording;
  @override
  final FileManifestEntry? meta;
  @override
  @JsonKey(name: 'input_log')
  final FileManifestEntry? inputLog;
  @override
  final FileManifestEntry? sft;

  @override
  String toString() {
    return 'FileManifest(recording: $recording, meta: $meta, inputLog: $inputLog, sft: $sft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileManifestImpl &&
            (identical(other.recording, recording) ||
                other.recording == recording) &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.inputLog, inputLog) ||
                other.inputLog == inputLog) &&
            (identical(other.sft, sft) || other.sft == sft));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recording, meta, inputLog, sft);

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileManifestImplCopyWith<_$FileManifestImpl> get copyWith =>
      __$$FileManifestImplCopyWithImpl<_$FileManifestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileManifestImplToJson(
      this,
    );
  }
}

abstract class _FileManifest implements FileManifest {
  const factory _FileManifest(
      {final FileManifestEntry? recording,
      final FileManifestEntry? meta,
      @JsonKey(name: 'input_log') final FileManifestEntry? inputLog,
      final FileManifestEntry? sft}) = _$FileManifestImpl;

  factory _FileManifest.fromJson(Map<String, dynamic> json) =
      _$FileManifestImpl.fromJson;

  @override
  FileManifestEntry? get recording;
  @override
  FileManifestEntry? get meta;
  @override
  @JsonKey(name: 'input_log')
  FileManifestEntry? get inputLog;
  @override
  FileManifestEntry? get sft;

  /// Create a copy of FileManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileManifestImplCopyWith<_$FileManifestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
