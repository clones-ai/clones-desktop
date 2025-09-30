// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_clip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoClip {
  String get id => throw _privateConstructorUsedError;
  double get start => throw _privateConstructorUsedError;
  double get end => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Create a copy of VideoClip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoClipCopyWith<VideoClip> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoClipCopyWith<$Res> {
  factory $VideoClipCopyWith(VideoClip value, $Res Function(VideoClip) then) =
      _$VideoClipCopyWithImpl<$Res, VideoClip>;
  @useResult
  $Res call({String id, double start, double end, bool isSelected});
}

/// @nodoc
class _$VideoClipCopyWithImpl<$Res, $Val extends VideoClip>
    implements $VideoClipCopyWith<$Res> {
  _$VideoClipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoClip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? start = null,
    Object? end = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as double,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as double,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoClipImplCopyWith<$Res>
    implements $VideoClipCopyWith<$Res> {
  factory _$$VideoClipImplCopyWith(
          _$VideoClipImpl value, $Res Function(_$VideoClipImpl) then) =
      __$$VideoClipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double start, double end, bool isSelected});
}

/// @nodoc
class __$$VideoClipImplCopyWithImpl<$Res>
    extends _$VideoClipCopyWithImpl<$Res, _$VideoClipImpl>
    implements _$$VideoClipImplCopyWith<$Res> {
  __$$VideoClipImplCopyWithImpl(
      _$VideoClipImpl _value, $Res Function(_$VideoClipImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoClip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? start = null,
    Object? end = null,
    Object? isSelected = null,
  }) {
    return _then(_$VideoClipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as double,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as double,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$VideoClipImpl extends _VideoClip {
  const _$VideoClipImpl(
      {required this.id,
      required this.start,
      required this.end,
      this.isSelected = false})
      : super._();

  @override
  final String id;
  @override
  final double start;
  @override
  final double end;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'VideoClip(id: $id, start: $start, end: $end, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoClipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, start, end, isSelected);

  /// Create a copy of VideoClip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoClipImplCopyWith<_$VideoClipImpl> get copyWith =>
      __$$VideoClipImplCopyWithImpl<_$VideoClipImpl>(this, _$identity);
}

abstract class _VideoClip extends VideoClip {
  const factory _VideoClip(
      {required final String id,
      required final double start,
      required final double end,
      final bool isSelected}) = _$VideoClipImpl;
  const _VideoClip._() : super._();

  @override
  String get id;
  @override
  double get start;
  @override
  double get end;
  @override
  bool get isSelected;

  /// Create a copy of VideoClip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoClipImplCopyWith<_$VideoClipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
