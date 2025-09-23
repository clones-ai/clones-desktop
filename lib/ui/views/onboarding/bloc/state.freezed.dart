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
mixin _$OnboardingDataState {
  bool get privacyAccepted => throw _privateConstructorUsedError;
  OnboardingStep get currentStep => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingDataStateCopyWith<OnboardingDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingDataStateCopyWith<$Res> {
  factory $OnboardingDataStateCopyWith(
          OnboardingDataState value, $Res Function(OnboardingDataState) then) =
      _$OnboardingDataStateCopyWithImpl<$Res, OnboardingDataState>;
  @useResult
  $Res call({bool privacyAccepted, OnboardingStep currentStep});
}

/// @nodoc
class _$OnboardingDataStateCopyWithImpl<$Res, $Val extends OnboardingDataState>
    implements $OnboardingDataStateCopyWith<$Res> {
  _$OnboardingDataStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privacyAccepted = null,
    Object? currentStep = null,
  }) {
    return _then(_value.copyWith(
      privacyAccepted: null == privacyAccepted
          ? _value.privacyAccepted
          : privacyAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingDataStateImplCopyWith<$Res>
    implements $OnboardingDataStateCopyWith<$Res> {
  factory _$$OnboardingDataStateImplCopyWith(_$OnboardingDataStateImpl value,
          $Res Function(_$OnboardingDataStateImpl) then) =
      __$$OnboardingDataStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool privacyAccepted, OnboardingStep currentStep});
}

/// @nodoc
class __$$OnboardingDataStateImplCopyWithImpl<$Res>
    extends _$OnboardingDataStateCopyWithImpl<$Res, _$OnboardingDataStateImpl>
    implements _$$OnboardingDataStateImplCopyWith<$Res> {
  __$$OnboardingDataStateImplCopyWithImpl(_$OnboardingDataStateImpl _value,
      $Res Function(_$OnboardingDataStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privacyAccepted = null,
    Object? currentStep = null,
  }) {
    return _then(_$OnboardingDataStateImpl(
      privacyAccepted: null == privacyAccepted
          ? _value.privacyAccepted
          : privacyAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
    ));
  }
}

/// @nodoc

class _$OnboardingDataStateImpl extends _OnboardingDataState {
  const _$OnboardingDataStateImpl(
      {required this.privacyAccepted, required this.currentStep})
      : super._();

  @override
  final bool privacyAccepted;
  @override
  final OnboardingStep currentStep;

  @override
  String toString() {
    return 'OnboardingDataState(privacyAccepted: $privacyAccepted, currentStep: $currentStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingDataStateImpl &&
            (identical(other.privacyAccepted, privacyAccepted) ||
                other.privacyAccepted == privacyAccepted) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep));
  }

  @override
  int get hashCode => Object.hash(runtimeType, privacyAccepted, currentStep);

  /// Create a copy of OnboardingDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingDataStateImplCopyWith<_$OnboardingDataStateImpl> get copyWith =>
      __$$OnboardingDataStateImplCopyWithImpl<_$OnboardingDataStateImpl>(
          this, _$identity);
}

abstract class _OnboardingDataState extends OnboardingDataState {
  const factory _OnboardingDataState(
      {required final bool privacyAccepted,
      required final OnboardingStep currentStep}) = _$OnboardingDataStateImpl;
  const _OnboardingDataState._() : super._();

  @override
  bool get privacyAccepted;
  @override
  OnboardingStep get currentStep;

  /// Create a copy of OnboardingDataState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingDataStateImplCopyWith<_$OnboardingDataStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
