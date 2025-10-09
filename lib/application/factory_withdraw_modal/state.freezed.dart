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
mixin _$FactoryWithdrawModalState {
  Factory? get factory => throw _privateConstructorUsedError;
  bool get isShown => throw _privateConstructorUsedError;
  String get withdrawAmount => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isWithdrawing => throw _privateConstructorUsedError;
  String? get estimatedGasCost => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get gasExceedsAmount => throw _privateConstructorUsedError;
  String? get maxSafeWithdrawal => throw _privateConstructorUsedError;
  bool get validationLoading => throw _privateConstructorUsedError;
  WithdrawalValidation? get validationResult =>
      throw _privateConstructorUsedError;
  PoolHealth? get poolHealth => throw _privateConstructorUsedError;

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactoryWithdrawModalStateCopyWith<FactoryWithdrawModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactoryWithdrawModalStateCopyWith<$Res> {
  factory $FactoryWithdrawModalStateCopyWith(FactoryWithdrawModalState value,
          $Res Function(FactoryWithdrawModalState) then) =
      _$FactoryWithdrawModalStateCopyWithImpl<$Res, FactoryWithdrawModalState>;
  @useResult
  $Res call(
      {Factory? factory,
      bool isShown,
      String withdrawAmount,
      bool isLoading,
      bool isWithdrawing,
      String? estimatedGasCost,
      String? error,
      bool gasExceedsAmount,
      String? maxSafeWithdrawal,
      bool validationLoading,
      WithdrawalValidation? validationResult,
      PoolHealth? poolHealth});

  $FactoryCopyWith<$Res>? get factory;
  $WithdrawalValidationCopyWith<$Res>? get validationResult;
  $PoolHealthCopyWith<$Res>? get poolHealth;
}

/// @nodoc
class _$FactoryWithdrawModalStateCopyWithImpl<$Res,
        $Val extends FactoryWithdrawModalState>
    implements $FactoryWithdrawModalStateCopyWith<$Res> {
  _$FactoryWithdrawModalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? factory = freezed,
    Object? isShown = null,
    Object? withdrawAmount = null,
    Object? isLoading = null,
    Object? isWithdrawing = null,
    Object? estimatedGasCost = freezed,
    Object? error = freezed,
    Object? gasExceedsAmount = null,
    Object? maxSafeWithdrawal = freezed,
    Object? validationLoading = null,
    Object? validationResult = freezed,
    Object? poolHealth = freezed,
  }) {
    return _then(_value.copyWith(
      factory: freezed == factory
          ? _value.factory
          : factory // ignore: cast_nullable_to_non_nullable
              as Factory?,
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      withdrawAmount: null == withdrawAmount
          ? _value.withdrawAmount
          : withdrawAmount // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isWithdrawing: null == isWithdrawing
          ? _value.isWithdrawing
          : isWithdrawing // ignore: cast_nullable_to_non_nullable
              as bool,
      estimatedGasCost: freezed == estimatedGasCost
          ? _value.estimatedGasCost
          : estimatedGasCost // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      gasExceedsAmount: null == gasExceedsAmount
          ? _value.gasExceedsAmount
          : gasExceedsAmount // ignore: cast_nullable_to_non_nullable
              as bool,
      maxSafeWithdrawal: freezed == maxSafeWithdrawal
          ? _value.maxSafeWithdrawal
          : maxSafeWithdrawal // ignore: cast_nullable_to_non_nullable
              as String?,
      validationLoading: null == validationLoading
          ? _value.validationLoading
          : validationLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      validationResult: freezed == validationResult
          ? _value.validationResult
          : validationResult // ignore: cast_nullable_to_non_nullable
              as WithdrawalValidation?,
      poolHealth: freezed == poolHealth
          ? _value.poolHealth
          : poolHealth // ignore: cast_nullable_to_non_nullable
              as PoolHealth?,
    ) as $Val);
  }

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactoryCopyWith<$Res>? get factory {
    if (_value.factory == null) {
      return null;
    }

    return $FactoryCopyWith<$Res>(_value.factory!, (value) {
      return _then(_value.copyWith(factory: value) as $Val);
    });
  }

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WithdrawalValidationCopyWith<$Res>? get validationResult {
    if (_value.validationResult == null) {
      return null;
    }

    return $WithdrawalValidationCopyWith<$Res>(_value.validationResult!,
        (value) {
      return _then(_value.copyWith(validationResult: value) as $Val);
    });
  }

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PoolHealthCopyWith<$Res>? get poolHealth {
    if (_value.poolHealth == null) {
      return null;
    }

    return $PoolHealthCopyWith<$Res>(_value.poolHealth!, (value) {
      return _then(_value.copyWith(poolHealth: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FactoryWithdrawModalStateImplCopyWith<$Res>
    implements $FactoryWithdrawModalStateCopyWith<$Res> {
  factory _$$FactoryWithdrawModalStateImplCopyWith(
          _$FactoryWithdrawModalStateImpl value,
          $Res Function(_$FactoryWithdrawModalStateImpl) then) =
      __$$FactoryWithdrawModalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Factory? factory,
      bool isShown,
      String withdrawAmount,
      bool isLoading,
      bool isWithdrawing,
      String? estimatedGasCost,
      String? error,
      bool gasExceedsAmount,
      String? maxSafeWithdrawal,
      bool validationLoading,
      WithdrawalValidation? validationResult,
      PoolHealth? poolHealth});

  @override
  $FactoryCopyWith<$Res>? get factory;
  @override
  $WithdrawalValidationCopyWith<$Res>? get validationResult;
  @override
  $PoolHealthCopyWith<$Res>? get poolHealth;
}

/// @nodoc
class __$$FactoryWithdrawModalStateImplCopyWithImpl<$Res>
    extends _$FactoryWithdrawModalStateCopyWithImpl<$Res,
        _$FactoryWithdrawModalStateImpl>
    implements _$$FactoryWithdrawModalStateImplCopyWith<$Res> {
  __$$FactoryWithdrawModalStateImplCopyWithImpl(
      _$FactoryWithdrawModalStateImpl _value,
      $Res Function(_$FactoryWithdrawModalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? factory = freezed,
    Object? isShown = null,
    Object? withdrawAmount = null,
    Object? isLoading = null,
    Object? isWithdrawing = null,
    Object? estimatedGasCost = freezed,
    Object? error = freezed,
    Object? gasExceedsAmount = null,
    Object? maxSafeWithdrawal = freezed,
    Object? validationLoading = null,
    Object? validationResult = freezed,
    Object? poolHealth = freezed,
  }) {
    return _then(_$FactoryWithdrawModalStateImpl(
      factory: freezed == factory
          ? _value.factory
          : factory // ignore: cast_nullable_to_non_nullable
              as Factory?,
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      withdrawAmount: null == withdrawAmount
          ? _value.withdrawAmount
          : withdrawAmount // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isWithdrawing: null == isWithdrawing
          ? _value.isWithdrawing
          : isWithdrawing // ignore: cast_nullable_to_non_nullable
              as bool,
      estimatedGasCost: freezed == estimatedGasCost
          ? _value.estimatedGasCost
          : estimatedGasCost // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      gasExceedsAmount: null == gasExceedsAmount
          ? _value.gasExceedsAmount
          : gasExceedsAmount // ignore: cast_nullable_to_non_nullable
              as bool,
      maxSafeWithdrawal: freezed == maxSafeWithdrawal
          ? _value.maxSafeWithdrawal
          : maxSafeWithdrawal // ignore: cast_nullable_to_non_nullable
              as String?,
      validationLoading: null == validationLoading
          ? _value.validationLoading
          : validationLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      validationResult: freezed == validationResult
          ? _value.validationResult
          : validationResult // ignore: cast_nullable_to_non_nullable
              as WithdrawalValidation?,
      poolHealth: freezed == poolHealth
          ? _value.poolHealth
          : poolHealth // ignore: cast_nullable_to_non_nullable
              as PoolHealth?,
    ));
  }
}

/// @nodoc

class _$FactoryWithdrawModalStateImpl extends _FactoryWithdrawModalState {
  const _$FactoryWithdrawModalStateImpl(
      {this.factory,
      this.isShown = false,
      this.withdrawAmount = '',
      this.isLoading = false,
      this.isWithdrawing = false,
      this.estimatedGasCost,
      this.error,
      this.gasExceedsAmount = false,
      this.maxSafeWithdrawal,
      this.validationLoading = false,
      this.validationResult,
      this.poolHealth})
      : super._();

  @override
  final Factory? factory;
  @override
  @JsonKey()
  final bool isShown;
  @override
  @JsonKey()
  final String withdrawAmount;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isWithdrawing;
  @override
  final String? estimatedGasCost;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool gasExceedsAmount;
  @override
  final String? maxSafeWithdrawal;
  @override
  @JsonKey()
  final bool validationLoading;
  @override
  final WithdrawalValidation? validationResult;
  @override
  final PoolHealth? poolHealth;

  @override
  String toString() {
    return 'FactoryWithdrawModalState(factory: $factory, isShown: $isShown, withdrawAmount: $withdrawAmount, isLoading: $isLoading, isWithdrawing: $isWithdrawing, estimatedGasCost: $estimatedGasCost, error: $error, gasExceedsAmount: $gasExceedsAmount, maxSafeWithdrawal: $maxSafeWithdrawal, validationLoading: $validationLoading, validationResult: $validationResult, poolHealth: $poolHealth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactoryWithdrawModalStateImpl &&
            (identical(other.factory, factory) || other.factory == factory) &&
            (identical(other.isShown, isShown) || other.isShown == isShown) &&
            (identical(other.withdrawAmount, withdrawAmount) ||
                other.withdrawAmount == withdrawAmount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isWithdrawing, isWithdrawing) ||
                other.isWithdrawing == isWithdrawing) &&
            (identical(other.estimatedGasCost, estimatedGasCost) ||
                other.estimatedGasCost == estimatedGasCost) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.gasExceedsAmount, gasExceedsAmount) ||
                other.gasExceedsAmount == gasExceedsAmount) &&
            (identical(other.maxSafeWithdrawal, maxSafeWithdrawal) ||
                other.maxSafeWithdrawal == maxSafeWithdrawal) &&
            (identical(other.validationLoading, validationLoading) ||
                other.validationLoading == validationLoading) &&
            (identical(other.validationResult, validationResult) ||
                other.validationResult == validationResult) &&
            (identical(other.poolHealth, poolHealth) ||
                other.poolHealth == poolHealth));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      factory,
      isShown,
      withdrawAmount,
      isLoading,
      isWithdrawing,
      estimatedGasCost,
      error,
      gasExceedsAmount,
      maxSafeWithdrawal,
      validationLoading,
      validationResult,
      poolHealth);

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactoryWithdrawModalStateImplCopyWith<_$FactoryWithdrawModalStateImpl>
      get copyWith => __$$FactoryWithdrawModalStateImplCopyWithImpl<
          _$FactoryWithdrawModalStateImpl>(this, _$identity);
}

abstract class _FactoryWithdrawModalState extends FactoryWithdrawModalState {
  const factory _FactoryWithdrawModalState(
      {final Factory? factory,
      final bool isShown,
      final String withdrawAmount,
      final bool isLoading,
      final bool isWithdrawing,
      final String? estimatedGasCost,
      final String? error,
      final bool gasExceedsAmount,
      final String? maxSafeWithdrawal,
      final bool validationLoading,
      final WithdrawalValidation? validationResult,
      final PoolHealth? poolHealth}) = _$FactoryWithdrawModalStateImpl;
  const _FactoryWithdrawModalState._() : super._();

  @override
  Factory? get factory;
  @override
  bool get isShown;
  @override
  String get withdrawAmount;
  @override
  bool get isLoading;
  @override
  bool get isWithdrawing;
  @override
  String? get estimatedGasCost;
  @override
  String? get error;
  @override
  bool get gasExceedsAmount;
  @override
  String? get maxSafeWithdrawal;
  @override
  bool get validationLoading;
  @override
  WithdrawalValidation? get validationResult;
  @override
  PoolHealth? get poolHealth;

  /// Create a copy of FactoryWithdrawModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactoryWithdrawModalStateImplCopyWith<_$FactoryWithdrawModalStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
