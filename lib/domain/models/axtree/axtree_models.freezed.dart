// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'axtree_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AxTreeBbox _$AxTreeBboxFromJson(Map<String, dynamic> json) {
  return _AxTreeBbox.fromJson(json);
}

/// @nodoc
mixin _$AxTreeBbox {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;

  /// Serializes this AxTreeBbox to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeBbox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeBboxCopyWith<AxTreeBbox> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeBboxCopyWith<$Res> {
  factory $AxTreeBboxCopyWith(
          AxTreeBbox value, $Res Function(AxTreeBbox) then) =
      _$AxTreeBboxCopyWithImpl<$Res, AxTreeBbox>;
  @useResult
  $Res call({double x, double y, double width, double height});
}

/// @nodoc
class _$AxTreeBboxCopyWithImpl<$Res, $Val extends AxTreeBbox>
    implements $AxTreeBboxCopyWith<$Res> {
  _$AxTreeBboxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeBbox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AxTreeBboxImplCopyWith<$Res>
    implements $AxTreeBboxCopyWith<$Res> {
  factory _$$AxTreeBboxImplCopyWith(
          _$AxTreeBboxImpl value, $Res Function(_$AxTreeBboxImpl) then) =
      __$$AxTreeBboxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y, double width, double height});
}

/// @nodoc
class __$$AxTreeBboxImplCopyWithImpl<$Res>
    extends _$AxTreeBboxCopyWithImpl<$Res, _$AxTreeBboxImpl>
    implements _$$AxTreeBboxImplCopyWith<$Res> {
  __$$AxTreeBboxImplCopyWithImpl(
      _$AxTreeBboxImpl _value, $Res Function(_$AxTreeBboxImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeBbox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$AxTreeBboxImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreeBboxImpl implements _AxTreeBbox {
  const _$AxTreeBboxImpl(
      {required this.x,
      required this.y,
      required this.width,
      required this.height});

  factory _$AxTreeBboxImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreeBboxImplFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;

  @override
  String toString() {
    return 'AxTreeBbox(x: $x, y: $y, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeBboxImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, width, height);

  /// Create a copy of AxTreeBbox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeBboxImplCopyWith<_$AxTreeBboxImpl> get copyWith =>
      __$$AxTreeBboxImplCopyWithImpl<_$AxTreeBboxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreeBboxImplToJson(
      this,
    );
  }
}

abstract class _AxTreeBbox implements AxTreeBbox {
  const factory _AxTreeBbox(
      {required final double x,
      required final double y,
      required final double width,
      required final double height}) = _$AxTreeBboxImpl;

  factory _AxTreeBbox.fromJson(Map<String, dynamic> json) =
      _$AxTreeBboxImpl.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get width;
  @override
  double get height;

  /// Create a copy of AxTreeBbox
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeBboxImplCopyWith<_$AxTreeBboxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AxTreeStates _$AxTreeStatesFromJson(Map<String, dynamic> json) {
  return _AxTreeStates.fromJson(json);
}

/// @nodoc
mixin _$AxTreeStates {
  bool get enabled => throw _privateConstructorUsedError;
  bool get visible => throw _privateConstructorUsedError;
  @JsonKey(name: 'keyboard_focusable')
  bool get keyboardFocusable => throw _privateConstructorUsedError;

  /// Serializes this AxTreeStates to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeStatesCopyWith<AxTreeStates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeStatesCopyWith<$Res> {
  factory $AxTreeStatesCopyWith(
          AxTreeStates value, $Res Function(AxTreeStates) then) =
      _$AxTreeStatesCopyWithImpl<$Res, AxTreeStates>;
  @useResult
  $Res call(
      {bool enabled,
      bool visible,
      @JsonKey(name: 'keyboard_focusable') bool keyboardFocusable});
}

/// @nodoc
class _$AxTreeStatesCopyWithImpl<$Res, $Val extends AxTreeStates>
    implements $AxTreeStatesCopyWith<$Res> {
  _$AxTreeStatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? visible = null,
    Object? keyboardFocusable = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      keyboardFocusable: null == keyboardFocusable
          ? _value.keyboardFocusable
          : keyboardFocusable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AxTreeStatesImplCopyWith<$Res>
    implements $AxTreeStatesCopyWith<$Res> {
  factory _$$AxTreeStatesImplCopyWith(
          _$AxTreeStatesImpl value, $Res Function(_$AxTreeStatesImpl) then) =
      __$$AxTreeStatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool visible,
      @JsonKey(name: 'keyboard_focusable') bool keyboardFocusable});
}

/// @nodoc
class __$$AxTreeStatesImplCopyWithImpl<$Res>
    extends _$AxTreeStatesCopyWithImpl<$Res, _$AxTreeStatesImpl>
    implements _$$AxTreeStatesImplCopyWith<$Res> {
  __$$AxTreeStatesImplCopyWithImpl(
      _$AxTreeStatesImpl _value, $Res Function(_$AxTreeStatesImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? visible = null,
    Object? keyboardFocusable = null,
  }) {
    return _then(_$AxTreeStatesImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      keyboardFocusable: null == keyboardFocusable
          ? _value.keyboardFocusable
          : keyboardFocusable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreeStatesImpl implements _AxTreeStates {
  const _$AxTreeStatesImpl(
      {this.enabled = false,
      this.visible = false,
      @JsonKey(name: 'keyboard_focusable') this.keyboardFocusable = false});

  factory _$AxTreeStatesImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreeStatesImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey(name: 'keyboard_focusable')
  final bool keyboardFocusable;

  @override
  String toString() {
    return 'AxTreeStates(enabled: $enabled, visible: $visible, keyboardFocusable: $keyboardFocusable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeStatesImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.keyboardFocusable, keyboardFocusable) ||
                other.keyboardFocusable == keyboardFocusable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, enabled, visible, keyboardFocusable);

  /// Create a copy of AxTreeStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeStatesImplCopyWith<_$AxTreeStatesImpl> get copyWith =>
      __$$AxTreeStatesImplCopyWithImpl<_$AxTreeStatesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreeStatesImplToJson(
      this,
    );
  }
}

abstract class _AxTreeStates implements AxTreeStates {
  const factory _AxTreeStates(
          {final bool enabled,
          final bool visible,
          @JsonKey(name: 'keyboard_focusable') final bool keyboardFocusable}) =
      _$AxTreeStatesImpl;

  factory _AxTreeStates.fromJson(Map<String, dynamic> json) =
      _$AxTreeStatesImpl.fromJson;

  @override
  bool get enabled;
  @override
  bool get visible;
  @override
  @JsonKey(name: 'keyboard_focusable')
  bool get keyboardFocusable;

  /// Create a copy of AxTreeStates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeStatesImplCopyWith<_$AxTreeStatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AxTreeElement _$AxTreeElementFromJson(Map<String, dynamic> json) {
  return _AxTreeElement.fromJson(json);
}

/// @nodoc
mixin _$AxTreeElement {
  AxTreeBbox? get bbox => throw _privateConstructorUsedError;
  List<AxTreeElement> get children => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  AxTreeStates? get states => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this AxTreeElement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeElementCopyWith<AxTreeElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeElementCopyWith<$Res> {
  factory $AxTreeElementCopyWith(
          AxTreeElement value, $Res Function(AxTreeElement) then) =
      _$AxTreeElementCopyWithImpl<$Res, AxTreeElement>;
  @useResult
  $Res call(
      {AxTreeBbox? bbox,
      List<AxTreeElement> children,
      String description,
      String name,
      String role,
      AxTreeStates? states,
      String value});

  $AxTreeBboxCopyWith<$Res>? get bbox;
  $AxTreeStatesCopyWith<$Res>? get states;
}

/// @nodoc
class _$AxTreeElementCopyWithImpl<$Res, $Val extends AxTreeElement>
    implements $AxTreeElementCopyWith<$Res> {
  _$AxTreeElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbox = freezed,
    Object? children = null,
    Object? description = null,
    Object? name = null,
    Object? role = null,
    Object? states = freezed,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      bbox: freezed == bbox
          ? _value.bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as AxTreeBbox?,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<AxTreeElement>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      states: freezed == states
          ? _value.states
          : states // ignore: cast_nullable_to_non_nullable
              as AxTreeStates?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AxTreeBboxCopyWith<$Res>? get bbox {
    if (_value.bbox == null) {
      return null;
    }

    return $AxTreeBboxCopyWith<$Res>(_value.bbox!, (value) {
      return _then(_value.copyWith(bbox: value) as $Val);
    });
  }

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AxTreeStatesCopyWith<$Res>? get states {
    if (_value.states == null) {
      return null;
    }

    return $AxTreeStatesCopyWith<$Res>(_value.states!, (value) {
      return _then(_value.copyWith(states: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AxTreeElementImplCopyWith<$Res>
    implements $AxTreeElementCopyWith<$Res> {
  factory _$$AxTreeElementImplCopyWith(
          _$AxTreeElementImpl value, $Res Function(_$AxTreeElementImpl) then) =
      __$$AxTreeElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AxTreeBbox? bbox,
      List<AxTreeElement> children,
      String description,
      String name,
      String role,
      AxTreeStates? states,
      String value});

  @override
  $AxTreeBboxCopyWith<$Res>? get bbox;
  @override
  $AxTreeStatesCopyWith<$Res>? get states;
}

/// @nodoc
class __$$AxTreeElementImplCopyWithImpl<$Res>
    extends _$AxTreeElementCopyWithImpl<$Res, _$AxTreeElementImpl>
    implements _$$AxTreeElementImplCopyWith<$Res> {
  __$$AxTreeElementImplCopyWithImpl(
      _$AxTreeElementImpl _value, $Res Function(_$AxTreeElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbox = freezed,
    Object? children = null,
    Object? description = null,
    Object? name = null,
    Object? role = null,
    Object? states = freezed,
    Object? value = null,
  }) {
    return _then(_$AxTreeElementImpl(
      bbox: freezed == bbox
          ? _value.bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as AxTreeBbox?,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<AxTreeElement>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      states: freezed == states
          ? _value.states
          : states // ignore: cast_nullable_to_non_nullable
              as AxTreeStates?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreeElementImpl implements _AxTreeElement {
  const _$AxTreeElementImpl(
      {this.bbox,
      final List<AxTreeElement> children = const [],
      this.description = '',
      this.name = '',
      this.role = '',
      this.states,
      this.value = ''})
      : _children = children;

  factory _$AxTreeElementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreeElementImplFromJson(json);

  @override
  final AxTreeBbox? bbox;
  final List<AxTreeElement> _children;
  @override
  @JsonKey()
  List<AxTreeElement> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String role;
  @override
  final AxTreeStates? states;
  @override
  @JsonKey()
  final String value;

  @override
  String toString() {
    return 'AxTreeElement(bbox: $bbox, children: $children, description: $description, name: $name, role: $role, states: $states, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeElementImpl &&
            (identical(other.bbox, bbox) || other.bbox == bbox) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.states, states) || other.states == states) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bbox,
      const DeepCollectionEquality().hash(_children),
      description,
      name,
      role,
      states,
      value);

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeElementImplCopyWith<_$AxTreeElementImpl> get copyWith =>
      __$$AxTreeElementImplCopyWithImpl<_$AxTreeElementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreeElementImplToJson(
      this,
    );
  }
}

abstract class _AxTreeElement implements AxTreeElement {
  const factory _AxTreeElement(
      {final AxTreeBbox? bbox,
      final List<AxTreeElement> children,
      final String description,
      final String name,
      final String role,
      final AxTreeStates? states,
      final String value}) = _$AxTreeElementImpl;

  factory _AxTreeElement.fromJson(Map<String, dynamic> json) =
      _$AxTreeElementImpl.fromJson;

  @override
  AxTreeBbox? get bbox;
  @override
  List<AxTreeElement> get children;
  @override
  String get description;
  @override
  String get name;
  @override
  String get role;
  @override
  AxTreeStates? get states;
  @override
  String get value;

  /// Create a copy of AxTreeElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeElementImplCopyWith<_$AxTreeElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AxTreePosition _$AxTreePositionFromJson(Map<String, dynamic> json) {
  return _AxTreePosition.fromJson(json);
}

/// @nodoc
mixin _$AxTreePosition {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Serializes this AxTreePosition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreePosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreePositionCopyWith<AxTreePosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreePositionCopyWith<$Res> {
  factory $AxTreePositionCopyWith(
          AxTreePosition value, $Res Function(AxTreePosition) then) =
      _$AxTreePositionCopyWithImpl<$Res, AxTreePosition>;
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class _$AxTreePositionCopyWithImpl<$Res, $Val extends AxTreePosition>
    implements $AxTreePositionCopyWith<$Res> {
  _$AxTreePositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreePosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AxTreePositionImplCopyWith<$Res>
    implements $AxTreePositionCopyWith<$Res> {
  factory _$$AxTreePositionImplCopyWith(_$AxTreePositionImpl value,
          $Res Function(_$AxTreePositionImpl) then) =
      __$$AxTreePositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class __$$AxTreePositionImplCopyWithImpl<$Res>
    extends _$AxTreePositionCopyWithImpl<$Res, _$AxTreePositionImpl>
    implements _$$AxTreePositionImplCopyWith<$Res> {
  __$$AxTreePositionImplCopyWithImpl(
      _$AxTreePositionImpl _value, $Res Function(_$AxTreePositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreePosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_$AxTreePositionImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreePositionImpl implements _AxTreePosition {
  const _$AxTreePositionImpl({required this.x, required this.y});

  factory _$AxTreePositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreePositionImplFromJson(json);

  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'AxTreePosition(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreePositionImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of AxTreePosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreePositionImplCopyWith<_$AxTreePositionImpl> get copyWith =>
      __$$AxTreePositionImplCopyWithImpl<_$AxTreePositionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreePositionImplToJson(
      this,
    );
  }
}

abstract class _AxTreePosition implements AxTreePosition {
  const factory _AxTreePosition(
      {required final double x,
      required final double y}) = _$AxTreePositionImpl;

  factory _AxTreePosition.fromJson(Map<String, dynamic> json) =
      _$AxTreePositionImpl.fromJson;

  @override
  double get x;
  @override
  double get y;

  /// Create a copy of AxTreePosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreePositionImplCopyWith<_$AxTreePositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AxTreeQuery _$AxTreeQueryFromJson(Map<String, dynamic> json) {
  return _AxTreeQuery.fromJson(json);
}

/// @nodoc
mixin _$AxTreeQuery {
  AxTreeElement? get element => throw _privateConstructorUsedError;
  AxTreePosition? get position => throw _privateConstructorUsedError;

  /// Serializes this AxTreeQuery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeQueryCopyWith<AxTreeQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeQueryCopyWith<$Res> {
  factory $AxTreeQueryCopyWith(
          AxTreeQuery value, $Res Function(AxTreeQuery) then) =
      _$AxTreeQueryCopyWithImpl<$Res, AxTreeQuery>;
  @useResult
  $Res call({AxTreeElement? element, AxTreePosition? position});

  $AxTreeElementCopyWith<$Res>? get element;
  $AxTreePositionCopyWith<$Res>? get position;
}

/// @nodoc
class _$AxTreeQueryCopyWithImpl<$Res, $Val extends AxTreeQuery>
    implements $AxTreeQueryCopyWith<$Res> {
  _$AxTreeQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = freezed,
    Object? position = freezed,
  }) {
    return _then(_value.copyWith(
      element: freezed == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as AxTreeElement?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as AxTreePosition?,
    ) as $Val);
  }

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AxTreeElementCopyWith<$Res>? get element {
    if (_value.element == null) {
      return null;
    }

    return $AxTreeElementCopyWith<$Res>(_value.element!, (value) {
      return _then(_value.copyWith(element: value) as $Val);
    });
  }

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AxTreePositionCopyWith<$Res>? get position {
    if (_value.position == null) {
      return null;
    }

    return $AxTreePositionCopyWith<$Res>(_value.position!, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AxTreeQueryImplCopyWith<$Res>
    implements $AxTreeQueryCopyWith<$Res> {
  factory _$$AxTreeQueryImplCopyWith(
          _$AxTreeQueryImpl value, $Res Function(_$AxTreeQueryImpl) then) =
      __$$AxTreeQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AxTreeElement? element, AxTreePosition? position});

  @override
  $AxTreeElementCopyWith<$Res>? get element;
  @override
  $AxTreePositionCopyWith<$Res>? get position;
}

/// @nodoc
class __$$AxTreeQueryImplCopyWithImpl<$Res>
    extends _$AxTreeQueryCopyWithImpl<$Res, _$AxTreeQueryImpl>
    implements _$$AxTreeQueryImplCopyWith<$Res> {
  __$$AxTreeQueryImplCopyWithImpl(
      _$AxTreeQueryImpl _value, $Res Function(_$AxTreeQueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = freezed,
    Object? position = freezed,
  }) {
    return _then(_$AxTreeQueryImpl(
      element: freezed == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as AxTreeElement?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as AxTreePosition?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreeQueryImpl implements _AxTreeQuery {
  const _$AxTreeQueryImpl({this.element, this.position});

  factory _$AxTreeQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreeQueryImplFromJson(json);

  @override
  final AxTreeElement? element;
  @override
  final AxTreePosition? position;

  @override
  String toString() {
    return 'AxTreeQuery(element: $element, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeQueryImpl &&
            (identical(other.element, element) || other.element == element) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, element, position);

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeQueryImplCopyWith<_$AxTreeQueryImpl> get copyWith =>
      __$$AxTreeQueryImplCopyWithImpl<_$AxTreeQueryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreeQueryImplToJson(
      this,
    );
  }
}

abstract class _AxTreeQuery implements AxTreeQuery {
  const factory _AxTreeQuery(
      {final AxTreeElement? element,
      final AxTreePosition? position}) = _$AxTreeQueryImpl;

  factory _AxTreeQuery.fromJson(Map<String, dynamic> json) =
      _$AxTreeQueryImpl.fromJson;

  @override
  AxTreeElement? get element;
  @override
  AxTreePosition? get position;

  /// Create a copy of AxTreeQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeQueryImplCopyWith<_$AxTreeQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AxTreeData _$AxTreeDataFromJson(Map<String, dynamic> json) {
  return _AxTreeData.fromJson(json);
}

/// @nodoc
mixin _$AxTreeData {
  int get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'focused_element')
  AxTreeElement? get focusedElement => throw _privateConstructorUsedError;
  Map<String, AxTreeQuery> get queries => throw _privateConstructorUsedError;
  List<AxTreeElement> get tree => throw _privateConstructorUsedError;

  /// Serializes this AxTreeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeDataCopyWith<AxTreeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeDataCopyWith<$Res> {
  factory $AxTreeDataCopyWith(
          AxTreeData value, $Res Function(AxTreeData) then) =
      _$AxTreeDataCopyWithImpl<$Res, AxTreeData>;
  @useResult
  $Res call(
      {int duration,
      @JsonKey(name: 'focused_element') AxTreeElement? focusedElement,
      Map<String, AxTreeQuery> queries,
      List<AxTreeElement> tree});

  $AxTreeElementCopyWith<$Res>? get focusedElement;
}

/// @nodoc
class _$AxTreeDataCopyWithImpl<$Res, $Val extends AxTreeData>
    implements $AxTreeDataCopyWith<$Res> {
  _$AxTreeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? focusedElement = freezed,
    Object? queries = null,
    Object? tree = null,
  }) {
    return _then(_value.copyWith(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      focusedElement: freezed == focusedElement
          ? _value.focusedElement
          : focusedElement // ignore: cast_nullable_to_non_nullable
              as AxTreeElement?,
      queries: null == queries
          ? _value.queries
          : queries // ignore: cast_nullable_to_non_nullable
              as Map<String, AxTreeQuery>,
      tree: null == tree
          ? _value.tree
          : tree // ignore: cast_nullable_to_non_nullable
              as List<AxTreeElement>,
    ) as $Val);
  }

  /// Create a copy of AxTreeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AxTreeElementCopyWith<$Res>? get focusedElement {
    if (_value.focusedElement == null) {
      return null;
    }

    return $AxTreeElementCopyWith<$Res>(_value.focusedElement!, (value) {
      return _then(_value.copyWith(focusedElement: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AxTreeDataImplCopyWith<$Res>
    implements $AxTreeDataCopyWith<$Res> {
  factory _$$AxTreeDataImplCopyWith(
          _$AxTreeDataImpl value, $Res Function(_$AxTreeDataImpl) then) =
      __$$AxTreeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int duration,
      @JsonKey(name: 'focused_element') AxTreeElement? focusedElement,
      Map<String, AxTreeQuery> queries,
      List<AxTreeElement> tree});

  @override
  $AxTreeElementCopyWith<$Res>? get focusedElement;
}

/// @nodoc
class __$$AxTreeDataImplCopyWithImpl<$Res>
    extends _$AxTreeDataCopyWithImpl<$Res, _$AxTreeDataImpl>
    implements _$$AxTreeDataImplCopyWith<$Res> {
  __$$AxTreeDataImplCopyWithImpl(
      _$AxTreeDataImpl _value, $Res Function(_$AxTreeDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? focusedElement = freezed,
    Object? queries = null,
    Object? tree = null,
  }) {
    return _then(_$AxTreeDataImpl(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      focusedElement: freezed == focusedElement
          ? _value.focusedElement
          : focusedElement // ignore: cast_nullable_to_non_nullable
              as AxTreeElement?,
      queries: null == queries
          ? _value._queries
          : queries // ignore: cast_nullable_to_non_nullable
              as Map<String, AxTreeQuery>,
      tree: null == tree
          ? _value._tree
          : tree // ignore: cast_nullable_to_non_nullable
              as List<AxTreeElement>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreeDataImpl implements _AxTreeData {
  const _$AxTreeDataImpl(
      {this.duration = 0,
      @JsonKey(name: 'focused_element') this.focusedElement,
      final Map<String, AxTreeQuery> queries = const {},
      final List<AxTreeElement> tree = const []})
      : _queries = queries,
        _tree = tree;

  factory _$AxTreeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreeDataImplFromJson(json);

  @override
  @JsonKey()
  final int duration;
  @override
  @JsonKey(name: 'focused_element')
  final AxTreeElement? focusedElement;
  final Map<String, AxTreeQuery> _queries;
  @override
  @JsonKey()
  Map<String, AxTreeQuery> get queries {
    if (_queries is EqualUnmodifiableMapView) return _queries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_queries);
  }

  final List<AxTreeElement> _tree;
  @override
  @JsonKey()
  List<AxTreeElement> get tree {
    if (_tree is EqualUnmodifiableListView) return _tree;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tree);
  }

  @override
  String toString() {
    return 'AxTreeData(duration: $duration, focusedElement: $focusedElement, queries: $queries, tree: $tree)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeDataImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.focusedElement, focusedElement) ||
                other.focusedElement == focusedElement) &&
            const DeepCollectionEquality().equals(other._queries, _queries) &&
            const DeepCollectionEquality().equals(other._tree, _tree));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      duration,
      focusedElement,
      const DeepCollectionEquality().hash(_queries),
      const DeepCollectionEquality().hash(_tree));

  /// Create a copy of AxTreeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeDataImplCopyWith<_$AxTreeDataImpl> get copyWith =>
      __$$AxTreeDataImplCopyWithImpl<_$AxTreeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreeDataImplToJson(
      this,
    );
  }
}

abstract class _AxTreeData implements AxTreeData {
  const factory _AxTreeData(
      {final int duration,
      @JsonKey(name: 'focused_element') final AxTreeElement? focusedElement,
      final Map<String, AxTreeQuery> queries,
      final List<AxTreeElement> tree}) = _$AxTreeDataImpl;

  factory _AxTreeData.fromJson(Map<String, dynamic> json) =
      _$AxTreeDataImpl.fromJson;

  @override
  int get duration;
  @override
  @JsonKey(name: 'focused_element')
  AxTreeElement? get focusedElement;
  @override
  Map<String, AxTreeQuery> get queries;
  @override
  List<AxTreeElement> get tree;

  /// Create a copy of AxTreeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeDataImplCopyWith<_$AxTreeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AxTreeEvent _$AxTreeEventFromJson(Map<String, dynamic> json) {
  return _AxTreeEvent.fromJson(json);
}

/// @nodoc
mixin _$AxTreeEvent {
  String get event => throw _privateConstructorUsedError;
  AxTreeData get data => throw _privateConstructorUsedError;
  int get time => throw _privateConstructorUsedError;

  /// Serializes this AxTreeEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeEventCopyWith<AxTreeEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeEventCopyWith<$Res> {
  factory $AxTreeEventCopyWith(
          AxTreeEvent value, $Res Function(AxTreeEvent) then) =
      _$AxTreeEventCopyWithImpl<$Res, AxTreeEvent>;
  @useResult
  $Res call({String event, AxTreeData data, int time});

  $AxTreeDataCopyWith<$Res> get data;
}

/// @nodoc
class _$AxTreeEventCopyWithImpl<$Res, $Val extends AxTreeEvent>
    implements $AxTreeEventCopyWith<$Res> {
  _$AxTreeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? data = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AxTreeData,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of AxTreeEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AxTreeDataCopyWith<$Res> get data {
    return $AxTreeDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AxTreeEventImplCopyWith<$Res>
    implements $AxTreeEventCopyWith<$Res> {
  factory _$$AxTreeEventImplCopyWith(
          _$AxTreeEventImpl value, $Res Function(_$AxTreeEventImpl) then) =
      __$$AxTreeEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String event, AxTreeData data, int time});

  @override
  $AxTreeDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$AxTreeEventImplCopyWithImpl<$Res>
    extends _$AxTreeEventCopyWithImpl<$Res, _$AxTreeEventImpl>
    implements _$$AxTreeEventImplCopyWith<$Res> {
  __$$AxTreeEventImplCopyWithImpl(
      _$AxTreeEventImpl _value, $Res Function(_$AxTreeEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? data = null,
    Object? time = null,
  }) {
    return _then(_$AxTreeEventImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AxTreeData,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AxTreeEventImpl implements _AxTreeEvent {
  const _$AxTreeEventImpl(
      {this.event = 'axtree', required this.data, required this.time});

  factory _$AxTreeEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AxTreeEventImplFromJson(json);

  @override
  @JsonKey()
  final String event;
  @override
  final AxTreeData data;
  @override
  final int time;

  @override
  String toString() {
    return 'AxTreeEvent(event: $event, data: $data, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeEventImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, event, data, time);

  /// Create a copy of AxTreeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeEventImplCopyWith<_$AxTreeEventImpl> get copyWith =>
      __$$AxTreeEventImplCopyWithImpl<_$AxTreeEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AxTreeEventImplToJson(
      this,
    );
  }
}

abstract class _AxTreeEvent implements AxTreeEvent {
  const factory _AxTreeEvent(
      {final String event,
      required final AxTreeData data,
      required final int time}) = _$AxTreeEventImpl;

  factory _AxTreeEvent.fromJson(Map<String, dynamic> json) =
      _$AxTreeEventImpl.fromJson;

  @override
  String get event;
  @override
  AxTreeData get data;
  @override
  int get time;

  /// Create a copy of AxTreeEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeEventImplCopyWith<_$AxTreeEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AxTreeBox {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  bool get isFocused => throw _privateConstructorUsedError;

  /// Create a copy of AxTreeBox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AxTreeBoxCopyWith<AxTreeBox> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxTreeBoxCopyWith<$Res> {
  factory $AxTreeBoxCopyWith(AxTreeBox value, $Res Function(AxTreeBox) then) =
      _$AxTreeBoxCopyWithImpl<$Res, AxTreeBox>;
  @useResult
  $Res call(
      {double x,
      double y,
      double width,
      double height,
      String name,
      String role,
      String description,
      String value,
      bool isFocused});
}

/// @nodoc
class _$AxTreeBoxCopyWithImpl<$Res, $Val extends AxTreeBox>
    implements $AxTreeBoxCopyWith<$Res> {
  _$AxTreeBoxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AxTreeBox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? name = null,
    Object? role = null,
    Object? description = null,
    Object? value = null,
    Object? isFocused = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      isFocused: null == isFocused
          ? _value.isFocused
          : isFocused // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AxTreeBoxImplCopyWith<$Res>
    implements $AxTreeBoxCopyWith<$Res> {
  factory _$$AxTreeBoxImplCopyWith(
          _$AxTreeBoxImpl value, $Res Function(_$AxTreeBoxImpl) then) =
      __$$AxTreeBoxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double x,
      double y,
      double width,
      double height,
      String name,
      String role,
      String description,
      String value,
      bool isFocused});
}

/// @nodoc
class __$$AxTreeBoxImplCopyWithImpl<$Res>
    extends _$AxTreeBoxCopyWithImpl<$Res, _$AxTreeBoxImpl>
    implements _$$AxTreeBoxImplCopyWith<$Res> {
  __$$AxTreeBoxImplCopyWithImpl(
      _$AxTreeBoxImpl _value, $Res Function(_$AxTreeBoxImpl) _then)
      : super(_value, _then);

  /// Create a copy of AxTreeBox
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? name = null,
    Object? role = null,
    Object? description = null,
    Object? value = null,
    Object? isFocused = null,
  }) {
    return _then(_$AxTreeBoxImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      isFocused: null == isFocused
          ? _value.isFocused
          : isFocused // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AxTreeBoxImpl implements _AxTreeBox {
  const _$AxTreeBoxImpl(
      {required this.x,
      required this.y,
      required this.width,
      required this.height,
      required this.name,
      required this.role,
      this.description = '',
      this.value = '',
      this.isFocused = false});

  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final String name;
  @override
  final String role;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String value;
  @override
  @JsonKey()
  final bool isFocused;

  @override
  String toString() {
    return 'AxTreeBox(x: $x, y: $y, width: $width, height: $height, name: $name, role: $role, description: $description, value: $value, isFocused: $isFocused)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxTreeBoxImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.isFocused, isFocused) ||
                other.isFocused == isFocused));
  }

  @override
  int get hashCode => Object.hash(runtimeType, x, y, width, height, name, role,
      description, value, isFocused);

  /// Create a copy of AxTreeBox
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AxTreeBoxImplCopyWith<_$AxTreeBoxImpl> get copyWith =>
      __$$AxTreeBoxImplCopyWithImpl<_$AxTreeBoxImpl>(this, _$identity);
}

abstract class _AxTreeBox implements AxTreeBox {
  const factory _AxTreeBox(
      {required final double x,
      required final double y,
      required final double width,
      required final double height,
      required final String name,
      required final String role,
      final String description,
      final String value,
      final bool isFocused}) = _$AxTreeBoxImpl;

  @override
  double get x;
  @override
  double get y;
  @override
  double get width;
  @override
  double get height;
  @override
  String get name;
  @override
  String get role;
  @override
  String get description;
  @override
  String get value;
  @override
  bool get isFocused;

  /// Create a copy of AxTreeBox
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AxTreeBoxImplCopyWith<_$AxTreeBoxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
