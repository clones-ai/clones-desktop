// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ForgeState {
  bool get showFactoryDetail => throw _privateConstructorUsedError;
  bool get showGenerateFactoryModal => throw _privateConstructorUsedError;
  Factory? get selectedFactory => throw _privateConstructorUsedError;

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgeStateCopyWith<ForgeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgeStateCopyWith<$Res> {
  factory $ForgeStateCopyWith(
          ForgeState value, $Res Function(ForgeState) then) =
      _$ForgeStateCopyWithImpl<$Res, ForgeState>;
  @useResult
  $Res call(
      {bool showFactoryDetail,
      bool showGenerateFactoryModal,
      Factory? selectedFactory});

  $FactoryCopyWith<$Res>? get selectedFactory;
}

/// @nodoc
class _$ForgeStateCopyWithImpl<$Res, $Val extends ForgeState>
    implements $ForgeStateCopyWith<$Res> {
  _$ForgeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showFactoryDetail = null,
    Object? showGenerateFactoryModal = null,
    Object? selectedFactory = freezed,
  }) {
    return _then(_value.copyWith(
      showFactoryDetail: null == showFactoryDetail
          ? _value.showFactoryDetail
          : showFactoryDetail // ignore: cast_nullable_to_non_nullable
              as bool,
      showGenerateFactoryModal: null == showGenerateFactoryModal
          ? _value.showGenerateFactoryModal
          : showGenerateFactoryModal // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedFactory: freezed == selectedFactory
          ? _value.selectedFactory
          : selectedFactory // ignore: cast_nullable_to_non_nullable
              as Factory?,
    ) as $Val);
  }

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactoryCopyWith<$Res>? get selectedFactory {
    if (_value.selectedFactory == null) {
      return null;
    }

    return $FactoryCopyWith<$Res>(_value.selectedFactory!, (value) {
      return _then(_value.copyWith(selectedFactory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ForgeStateImplCopyWith<$Res>
    implements $ForgeStateCopyWith<$Res> {
  factory _$$ForgeStateImplCopyWith(
          _$ForgeStateImpl value, $Res Function(_$ForgeStateImpl) then) =
      __$$ForgeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showFactoryDetail,
      bool showGenerateFactoryModal,
      Factory? selectedFactory});

  @override
  $FactoryCopyWith<$Res>? get selectedFactory;
}

/// @nodoc
class __$$ForgeStateImplCopyWithImpl<$Res>
    extends _$ForgeStateCopyWithImpl<$Res, _$ForgeStateImpl>
    implements _$$ForgeStateImplCopyWith<$Res> {
  __$$ForgeStateImplCopyWithImpl(
      _$ForgeStateImpl _value, $Res Function(_$ForgeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showFactoryDetail = null,
    Object? showGenerateFactoryModal = null,
    Object? selectedFactory = freezed,
  }) {
    return _then(_$ForgeStateImpl(
      showFactoryDetail: null == showFactoryDetail
          ? _value.showFactoryDetail
          : showFactoryDetail // ignore: cast_nullable_to_non_nullable
              as bool,
      showGenerateFactoryModal: null == showGenerateFactoryModal
          ? _value.showGenerateFactoryModal
          : showGenerateFactoryModal // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedFactory: freezed == selectedFactory
          ? _value.selectedFactory
          : selectedFactory // ignore: cast_nullable_to_non_nullable
              as Factory?,
    ));
  }
}

/// @nodoc

class _$ForgeStateImpl extends _ForgeState {
  const _$ForgeStateImpl(
      {this.showFactoryDetail = false,
      this.showGenerateFactoryModal = false,
      this.selectedFactory})
      : super._();

  @override
  @JsonKey()
  final bool showFactoryDetail;
  @override
  @JsonKey()
  final bool showGenerateFactoryModal;
  @override
  final Factory? selectedFactory;

  @override
  String toString() {
    return 'ForgeState(showFactoryDetail: $showFactoryDetail, showGenerateFactoryModal: $showGenerateFactoryModal, selectedFactory: $selectedFactory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgeStateImpl &&
            (identical(other.showFactoryDetail, showFactoryDetail) ||
                other.showFactoryDetail == showFactoryDetail) &&
            (identical(
                    other.showGenerateFactoryModal, showGenerateFactoryModal) ||
                other.showGenerateFactoryModal == showGenerateFactoryModal) &&
            (identical(other.selectedFactory, selectedFactory) ||
                other.selectedFactory == selectedFactory));
  }

  @override
  int get hashCode => Object.hash(runtimeType, showFactoryDetail,
      showGenerateFactoryModal, selectedFactory);

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgeStateImplCopyWith<_$ForgeStateImpl> get copyWith =>
      __$$ForgeStateImplCopyWithImpl<_$ForgeStateImpl>(this, _$identity);
}

abstract class _ForgeState extends ForgeState {
  const factory _ForgeState(
      {final bool showFactoryDetail,
      final bool showGenerateFactoryModal,
      final Factory? selectedFactory}) = _$ForgeStateImpl;
  const _ForgeState._() : super._();

  @override
  bool get showFactoryDetail;
  @override
  bool get showGenerateFactoryModal;
  @override
  Factory? get selectedFactory;

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgeStateImplCopyWith<_$ForgeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
