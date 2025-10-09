// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawal_validation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WithdrawalValidation _$WithdrawalValidationFromJson(Map<String, dynamic> json) {
  return _WithdrawalValidation.fromJson(json);
}

/// @nodoc
mixin _$WithdrawalValidation {
  bool get allowed => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String get maxSafeWithdrawal => throw _privateConstructorUsedError;
  String? get safetyBuffer => throw _privateConstructorUsedError;
  PoolState get poolState => throw _privateConstructorUsedError;

  /// Serializes this WithdrawalValidation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawalValidation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawalValidationCopyWith<WithdrawalValidation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawalValidationCopyWith<$Res> {
  factory $WithdrawalValidationCopyWith(WithdrawalValidation value,
          $Res Function(WithdrawalValidation) then) =
      _$WithdrawalValidationCopyWithImpl<$Res, WithdrawalValidation>;
  @useResult
  $Res call(
      {bool allowed,
      String? reason,
      String maxSafeWithdrawal,
      String? safetyBuffer,
      PoolState poolState});

  $PoolStateCopyWith<$Res> get poolState;
}

/// @nodoc
class _$WithdrawalValidationCopyWithImpl<$Res,
        $Val extends WithdrawalValidation>
    implements $WithdrawalValidationCopyWith<$Res> {
  _$WithdrawalValidationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawalValidation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowed = null,
    Object? reason = freezed,
    Object? maxSafeWithdrawal = null,
    Object? safetyBuffer = freezed,
    Object? poolState = null,
  }) {
    return _then(_value.copyWith(
      allowed: null == allowed
          ? _value.allowed
          : allowed // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSafeWithdrawal: null == maxSafeWithdrawal
          ? _value.maxSafeWithdrawal
          : maxSafeWithdrawal // ignore: cast_nullable_to_non_nullable
              as String,
      safetyBuffer: freezed == safetyBuffer
          ? _value.safetyBuffer
          : safetyBuffer // ignore: cast_nullable_to_non_nullable
              as String?,
      poolState: null == poolState
          ? _value.poolState
          : poolState // ignore: cast_nullable_to_non_nullable
              as PoolState,
    ) as $Val);
  }

  /// Create a copy of WithdrawalValidation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PoolStateCopyWith<$Res> get poolState {
    return $PoolStateCopyWith<$Res>(_value.poolState, (value) {
      return _then(_value.copyWith(poolState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WithdrawalValidationImplCopyWith<$Res>
    implements $WithdrawalValidationCopyWith<$Res> {
  factory _$$WithdrawalValidationImplCopyWith(_$WithdrawalValidationImpl value,
          $Res Function(_$WithdrawalValidationImpl) then) =
      __$$WithdrawalValidationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool allowed,
      String? reason,
      String maxSafeWithdrawal,
      String? safetyBuffer,
      PoolState poolState});

  @override
  $PoolStateCopyWith<$Res> get poolState;
}

/// @nodoc
class __$$WithdrawalValidationImplCopyWithImpl<$Res>
    extends _$WithdrawalValidationCopyWithImpl<$Res, _$WithdrawalValidationImpl>
    implements _$$WithdrawalValidationImplCopyWith<$Res> {
  __$$WithdrawalValidationImplCopyWithImpl(_$WithdrawalValidationImpl _value,
      $Res Function(_$WithdrawalValidationImpl) _then)
      : super(_value, _then);

  /// Create a copy of WithdrawalValidation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowed = null,
    Object? reason = freezed,
    Object? maxSafeWithdrawal = null,
    Object? safetyBuffer = freezed,
    Object? poolState = null,
  }) {
    return _then(_$WithdrawalValidationImpl(
      allowed: null == allowed
          ? _value.allowed
          : allowed // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSafeWithdrawal: null == maxSafeWithdrawal
          ? _value.maxSafeWithdrawal
          : maxSafeWithdrawal // ignore: cast_nullable_to_non_nullable
              as String,
      safetyBuffer: freezed == safetyBuffer
          ? _value.safetyBuffer
          : safetyBuffer // ignore: cast_nullable_to_non_nullable
              as String?,
      poolState: null == poolState
          ? _value.poolState
          : poolState // ignore: cast_nullable_to_non_nullable
              as PoolState,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WithdrawalValidationImpl implements _WithdrawalValidation {
  const _$WithdrawalValidationImpl(
      {required this.allowed,
      this.reason,
      required this.maxSafeWithdrawal,
      this.safetyBuffer,
      required this.poolState});

  factory _$WithdrawalValidationImpl.fromJson(Map<String, dynamic> json) =>
      _$$WithdrawalValidationImplFromJson(json);

  @override
  final bool allowed;
  @override
  final String? reason;
  @override
  final String maxSafeWithdrawal;
  @override
  final String? safetyBuffer;
  @override
  final PoolState poolState;

  @override
  String toString() {
    return 'WithdrawalValidation(allowed: $allowed, reason: $reason, maxSafeWithdrawal: $maxSafeWithdrawal, safetyBuffer: $safetyBuffer, poolState: $poolState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawalValidationImpl &&
            (identical(other.allowed, allowed) || other.allowed == allowed) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.maxSafeWithdrawal, maxSafeWithdrawal) ||
                other.maxSafeWithdrawal == maxSafeWithdrawal) &&
            (identical(other.safetyBuffer, safetyBuffer) ||
                other.safetyBuffer == safetyBuffer) &&
            (identical(other.poolState, poolState) ||
                other.poolState == poolState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, allowed, reason, maxSafeWithdrawal, safetyBuffer, poolState);

  /// Create a copy of WithdrawalValidation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawalValidationImplCopyWith<_$WithdrawalValidationImpl>
      get copyWith =>
          __$$WithdrawalValidationImplCopyWithImpl<_$WithdrawalValidationImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WithdrawalValidationImplToJson(
      this,
    );
  }
}

abstract class _WithdrawalValidation implements WithdrawalValidation {
  const factory _WithdrawalValidation(
      {required final bool allowed,
      final String? reason,
      required final String maxSafeWithdrawal,
      final String? safetyBuffer,
      required final PoolState poolState}) = _$WithdrawalValidationImpl;

  factory _WithdrawalValidation.fromJson(Map<String, dynamic> json) =
      _$WithdrawalValidationImpl.fromJson;

  @override
  bool get allowed;
  @override
  String? get reason;
  @override
  String get maxSafeWithdrawal;
  @override
  String? get safetyBuffer;
  @override
  PoolState get poolState;

  /// Create a copy of WithdrawalValidation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawalValidationImplCopyWith<_$WithdrawalValidationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PoolState _$PoolStateFromJson(Map<String, dynamic> json) {
  return _PoolState.fromJson(json);
}

/// @nodoc
mixin _$PoolState {
  String get address => throw _privateConstructorUsedError;
  String get creator => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get totalAllocated => throw _privateConstructorUsedError;
  String get totalClaimed => throw _privateConstructorUsedError;
  String get totalPending => throw _privateConstructorUsedError;
  int get allocationCount => throw _privateConstructorUsedError;
  List<PoolAllocation> get allocations => throw _privateConstructorUsedError;

  /// Serializes this PoolState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolStateCopyWith<PoolState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolStateCopyWith<$Res> {
  factory $PoolStateCopyWith(PoolState value, $Res Function(PoolState) then) =
      _$PoolStateCopyWithImpl<$Res, PoolState>;
  @useResult
  $Res call(
      {String address,
      String creator,
      String token,
      String balance,
      String totalAllocated,
      String totalClaimed,
      String totalPending,
      int allocationCount,
      List<PoolAllocation> allocations});
}

/// @nodoc
class _$PoolStateCopyWithImpl<$Res, $Val extends PoolState>
    implements $PoolStateCopyWith<$Res> {
  _$PoolStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? creator = null,
    Object? token = null,
    Object? balance = null,
    Object? totalAllocated = null,
    Object? totalClaimed = null,
    Object? totalPending = null,
    Object? allocationCount = null,
    Object? allocations = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      creator: null == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      totalAllocated: null == totalAllocated
          ? _value.totalAllocated
          : totalAllocated // ignore: cast_nullable_to_non_nullable
              as String,
      totalClaimed: null == totalClaimed
          ? _value.totalClaimed
          : totalClaimed // ignore: cast_nullable_to_non_nullable
              as String,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as String,
      allocationCount: null == allocationCount
          ? _value.allocationCount
          : allocationCount // ignore: cast_nullable_to_non_nullable
              as int,
      allocations: null == allocations
          ? _value.allocations
          : allocations // ignore: cast_nullable_to_non_nullable
              as List<PoolAllocation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PoolStateImplCopyWith<$Res>
    implements $PoolStateCopyWith<$Res> {
  factory _$$PoolStateImplCopyWith(
          _$PoolStateImpl value, $Res Function(_$PoolStateImpl) then) =
      __$$PoolStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String address,
      String creator,
      String token,
      String balance,
      String totalAllocated,
      String totalClaimed,
      String totalPending,
      int allocationCount,
      List<PoolAllocation> allocations});
}

/// @nodoc
class __$$PoolStateImplCopyWithImpl<$Res>
    extends _$PoolStateCopyWithImpl<$Res, _$PoolStateImpl>
    implements _$$PoolStateImplCopyWith<$Res> {
  __$$PoolStateImplCopyWithImpl(
      _$PoolStateImpl _value, $Res Function(_$PoolStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PoolState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? creator = null,
    Object? token = null,
    Object? balance = null,
    Object? totalAllocated = null,
    Object? totalClaimed = null,
    Object? totalPending = null,
    Object? allocationCount = null,
    Object? allocations = null,
  }) {
    return _then(_$PoolStateImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      creator: null == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      totalAllocated: null == totalAllocated
          ? _value.totalAllocated
          : totalAllocated // ignore: cast_nullable_to_non_nullable
              as String,
      totalClaimed: null == totalClaimed
          ? _value.totalClaimed
          : totalClaimed // ignore: cast_nullable_to_non_nullable
              as String,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as String,
      allocationCount: null == allocationCount
          ? _value.allocationCount
          : allocationCount // ignore: cast_nullable_to_non_nullable
              as int,
      allocations: null == allocations
          ? _value._allocations
          : allocations // ignore: cast_nullable_to_non_nullable
              as List<PoolAllocation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolStateImpl implements _PoolState {
  const _$PoolStateImpl(
      {required this.address,
      required this.creator,
      required this.token,
      required this.balance,
      required this.totalAllocated,
      required this.totalClaimed,
      required this.totalPending,
      required this.allocationCount,
      required final List<PoolAllocation> allocations})
      : _allocations = allocations;

  factory _$PoolStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolStateImplFromJson(json);

  @override
  final String address;
  @override
  final String creator;
  @override
  final String token;
  @override
  final String balance;
  @override
  final String totalAllocated;
  @override
  final String totalClaimed;
  @override
  final String totalPending;
  @override
  final int allocationCount;
  final List<PoolAllocation> _allocations;
  @override
  List<PoolAllocation> get allocations {
    if (_allocations is EqualUnmodifiableListView) return _allocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allocations);
  }

  @override
  String toString() {
    return 'PoolState(address: $address, creator: $creator, token: $token, balance: $balance, totalAllocated: $totalAllocated, totalClaimed: $totalClaimed, totalPending: $totalPending, allocationCount: $allocationCount, allocations: $allocations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolStateImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.totalAllocated, totalAllocated) ||
                other.totalAllocated == totalAllocated) &&
            (identical(other.totalClaimed, totalClaimed) ||
                other.totalClaimed == totalClaimed) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.allocationCount, allocationCount) ||
                other.allocationCount == allocationCount) &&
            const DeepCollectionEquality()
                .equals(other._allocations, _allocations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      creator,
      token,
      balance,
      totalAllocated,
      totalClaimed,
      totalPending,
      allocationCount,
      const DeepCollectionEquality().hash(_allocations));

  /// Create a copy of PoolState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolStateImplCopyWith<_$PoolStateImpl> get copyWith =>
      __$$PoolStateImplCopyWithImpl<_$PoolStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolStateImplToJson(
      this,
    );
  }
}

abstract class _PoolState implements PoolState {
  const factory _PoolState(
      {required final String address,
      required final String creator,
      required final String token,
      required final String balance,
      required final String totalAllocated,
      required final String totalClaimed,
      required final String totalPending,
      required final int allocationCount,
      required final List<PoolAllocation> allocations}) = _$PoolStateImpl;

  factory _PoolState.fromJson(Map<String, dynamic> json) =
      _$PoolStateImpl.fromJson;

  @override
  String get address;
  @override
  String get creator;
  @override
  String get token;
  @override
  String get balance;
  @override
  String get totalAllocated;
  @override
  String get totalClaimed;
  @override
  String get totalPending;
  @override
  int get allocationCount;
  @override
  List<PoolAllocation> get allocations;

  /// Create a copy of PoolState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolStateImplCopyWith<_$PoolStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoolAllocation _$PoolAllocationFromJson(Map<String, dynamic> json) {
  return _PoolAllocation.fromJson(json);
}

/// @nodoc
mixin _$PoolAllocation {
  String get farmerAddress => throw _privateConstructorUsedError;
  String get cumulativeAmount => throw _privateConstructorUsedError;
  String get alreadyClaimed => throw _privateConstructorUsedError;
  String get pendingAmount => throw _privateConstructorUsedError;

  /// Serializes this PoolAllocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolAllocationCopyWith<PoolAllocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolAllocationCopyWith<$Res> {
  factory $PoolAllocationCopyWith(
          PoolAllocation value, $Res Function(PoolAllocation) then) =
      _$PoolAllocationCopyWithImpl<$Res, PoolAllocation>;
  @useResult
  $Res call(
      {String farmerAddress,
      String cumulativeAmount,
      String alreadyClaimed,
      String pendingAmount});
}

/// @nodoc
class _$PoolAllocationCopyWithImpl<$Res, $Val extends PoolAllocation>
    implements $PoolAllocationCopyWith<$Res> {
  _$PoolAllocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolAllocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? farmerAddress = null,
    Object? cumulativeAmount = null,
    Object? alreadyClaimed = null,
    Object? pendingAmount = null,
  }) {
    return _then(_value.copyWith(
      farmerAddress: null == farmerAddress
          ? _value.farmerAddress
          : farmerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      cumulativeAmount: null == cumulativeAmount
          ? _value.cumulativeAmount
          : cumulativeAmount // ignore: cast_nullable_to_non_nullable
              as String,
      alreadyClaimed: null == alreadyClaimed
          ? _value.alreadyClaimed
          : alreadyClaimed // ignore: cast_nullable_to_non_nullable
              as String,
      pendingAmount: null == pendingAmount
          ? _value.pendingAmount
          : pendingAmount // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PoolAllocationImplCopyWith<$Res>
    implements $PoolAllocationCopyWith<$Res> {
  factory _$$PoolAllocationImplCopyWith(_$PoolAllocationImpl value,
          $Res Function(_$PoolAllocationImpl) then) =
      __$$PoolAllocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String farmerAddress,
      String cumulativeAmount,
      String alreadyClaimed,
      String pendingAmount});
}

/// @nodoc
class __$$PoolAllocationImplCopyWithImpl<$Res>
    extends _$PoolAllocationCopyWithImpl<$Res, _$PoolAllocationImpl>
    implements _$$PoolAllocationImplCopyWith<$Res> {
  __$$PoolAllocationImplCopyWithImpl(
      _$PoolAllocationImpl _value, $Res Function(_$PoolAllocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PoolAllocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? farmerAddress = null,
    Object? cumulativeAmount = null,
    Object? alreadyClaimed = null,
    Object? pendingAmount = null,
  }) {
    return _then(_$PoolAllocationImpl(
      farmerAddress: null == farmerAddress
          ? _value.farmerAddress
          : farmerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      cumulativeAmount: null == cumulativeAmount
          ? _value.cumulativeAmount
          : cumulativeAmount // ignore: cast_nullable_to_non_nullable
              as String,
      alreadyClaimed: null == alreadyClaimed
          ? _value.alreadyClaimed
          : alreadyClaimed // ignore: cast_nullable_to_non_nullable
              as String,
      pendingAmount: null == pendingAmount
          ? _value.pendingAmount
          : pendingAmount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolAllocationImpl implements _PoolAllocation {
  const _$PoolAllocationImpl(
      {required this.farmerAddress,
      required this.cumulativeAmount,
      required this.alreadyClaimed,
      required this.pendingAmount});

  factory _$PoolAllocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolAllocationImplFromJson(json);

  @override
  final String farmerAddress;
  @override
  final String cumulativeAmount;
  @override
  final String alreadyClaimed;
  @override
  final String pendingAmount;

  @override
  String toString() {
    return 'PoolAllocation(farmerAddress: $farmerAddress, cumulativeAmount: $cumulativeAmount, alreadyClaimed: $alreadyClaimed, pendingAmount: $pendingAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolAllocationImpl &&
            (identical(other.farmerAddress, farmerAddress) ||
                other.farmerAddress == farmerAddress) &&
            (identical(other.cumulativeAmount, cumulativeAmount) ||
                other.cumulativeAmount == cumulativeAmount) &&
            (identical(other.alreadyClaimed, alreadyClaimed) ||
                other.alreadyClaimed == alreadyClaimed) &&
            (identical(other.pendingAmount, pendingAmount) ||
                other.pendingAmount == pendingAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, farmerAddress, cumulativeAmount,
      alreadyClaimed, pendingAmount);

  /// Create a copy of PoolAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolAllocationImplCopyWith<_$PoolAllocationImpl> get copyWith =>
      __$$PoolAllocationImplCopyWithImpl<_$PoolAllocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolAllocationImplToJson(
      this,
    );
  }
}

abstract class _PoolAllocation implements PoolAllocation {
  const factory _PoolAllocation(
      {required final String farmerAddress,
      required final String cumulativeAmount,
      required final String alreadyClaimed,
      required final String pendingAmount}) = _$PoolAllocationImpl;

  factory _PoolAllocation.fromJson(Map<String, dynamic> json) =
      _$PoolAllocationImpl.fromJson;

  @override
  String get farmerAddress;
  @override
  String get cumulativeAmount;
  @override
  String get alreadyClaimed;
  @override
  String get pendingAmount;

  /// Create a copy of PoolAllocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolAllocationImplCopyWith<_$PoolAllocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoolHealth _$PoolHealthFromJson(Map<String, dynamic> json) {
  return _PoolHealth.fromJson(json);
}

/// @nodoc
mixin _$PoolHealth {
  String get poolAddress => throw _privateConstructorUsedError;
  bool get healthy => throw _privateConstructorUsedError;
  List<String> get alerts => throw _privateConstructorUsedError;
  HealthMetrics get metrics => throw _privateConstructorUsedError;
  PoolState get state => throw _privateConstructorUsedError;

  /// Serializes this PoolHealth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolHealthCopyWith<PoolHealth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolHealthCopyWith<$Res> {
  factory $PoolHealthCopyWith(
          PoolHealth value, $Res Function(PoolHealth) then) =
      _$PoolHealthCopyWithImpl<$Res, PoolHealth>;
  @useResult
  $Res call(
      {String poolAddress,
      bool healthy,
      List<String> alerts,
      HealthMetrics metrics,
      PoolState state});

  $HealthMetricsCopyWith<$Res> get metrics;
  $PoolStateCopyWith<$Res> get state;
}

/// @nodoc
class _$PoolHealthCopyWithImpl<$Res, $Val extends PoolHealth>
    implements $PoolHealthCopyWith<$Res> {
  _$PoolHealthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolAddress = null,
    Object? healthy = null,
    Object? alerts = null,
    Object? metrics = null,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      poolAddress: null == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String,
      healthy: null == healthy
          ? _value.healthy
          : healthy // ignore: cast_nullable_to_non_nullable
              as bool,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as HealthMetrics,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as PoolState,
    ) as $Val);
  }

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthMetricsCopyWith<$Res> get metrics {
    return $HealthMetricsCopyWith<$Res>(_value.metrics, (value) {
      return _then(_value.copyWith(metrics: value) as $Val);
    });
  }

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PoolStateCopyWith<$Res> get state {
    return $PoolStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PoolHealthImplCopyWith<$Res>
    implements $PoolHealthCopyWith<$Res> {
  factory _$$PoolHealthImplCopyWith(
          _$PoolHealthImpl value, $Res Function(_$PoolHealthImpl) then) =
      __$$PoolHealthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String poolAddress,
      bool healthy,
      List<String> alerts,
      HealthMetrics metrics,
      PoolState state});

  @override
  $HealthMetricsCopyWith<$Res> get metrics;
  @override
  $PoolStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$PoolHealthImplCopyWithImpl<$Res>
    extends _$PoolHealthCopyWithImpl<$Res, _$PoolHealthImpl>
    implements _$$PoolHealthImplCopyWith<$Res> {
  __$$PoolHealthImplCopyWithImpl(
      _$PoolHealthImpl _value, $Res Function(_$PoolHealthImpl) _then)
      : super(_value, _then);

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolAddress = null,
    Object? healthy = null,
    Object? alerts = null,
    Object? metrics = null,
    Object? state = null,
  }) {
    return _then(_$PoolHealthImpl(
      poolAddress: null == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String,
      healthy: null == healthy
          ? _value.healthy
          : healthy // ignore: cast_nullable_to_non_nullable
              as bool,
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as HealthMetrics,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as PoolState,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolHealthImpl implements _PoolHealth {
  const _$PoolHealthImpl(
      {required this.poolAddress,
      required this.healthy,
      required final List<String> alerts,
      required this.metrics,
      required this.state})
      : _alerts = alerts;

  factory _$PoolHealthImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolHealthImplFromJson(json);

  @override
  final String poolAddress;
  @override
  final bool healthy;
  final List<String> _alerts;
  @override
  List<String> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  final HealthMetrics metrics;
  @override
  final PoolState state;

  @override
  String toString() {
    return 'PoolHealth(poolAddress: $poolAddress, healthy: $healthy, alerts: $alerts, metrics: $metrics, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolHealthImpl &&
            (identical(other.poolAddress, poolAddress) ||
                other.poolAddress == poolAddress) &&
            (identical(other.healthy, healthy) || other.healthy == healthy) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            (identical(other.metrics, metrics) || other.metrics == metrics) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, poolAddress, healthy,
      const DeepCollectionEquality().hash(_alerts), metrics, state);

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolHealthImplCopyWith<_$PoolHealthImpl> get copyWith =>
      __$$PoolHealthImplCopyWithImpl<_$PoolHealthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolHealthImplToJson(
      this,
    );
  }
}

abstract class _PoolHealth implements PoolHealth {
  const factory _PoolHealth(
      {required final String poolAddress,
      required final bool healthy,
      required final List<String> alerts,
      required final HealthMetrics metrics,
      required final PoolState state}) = _$PoolHealthImpl;

  factory _PoolHealth.fromJson(Map<String, dynamic> json) =
      _$PoolHealthImpl.fromJson;

  @override
  String get poolAddress;
  @override
  bool get healthy;
  @override
  List<String> get alerts;
  @override
  HealthMetrics get metrics;
  @override
  PoolState get state;

  /// Create a copy of PoolHealth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolHealthImplCopyWith<_$PoolHealthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthMetrics _$HealthMetricsFromJson(Map<String, dynamic> json) {
  return _HealthMetrics.fromJson(json);
}

/// @nodoc
mixin _$HealthMetrics {
  double get utilization => throw _privateConstructorUsedError;
  double get coverage => throw _privateConstructorUsedError;
  int get pendingClaimsCount => throw _privateConstructorUsedError;
  String get totalPendingWithFees => throw _privateConstructorUsedError;

  /// Serializes this HealthMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthMetricsCopyWith<HealthMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthMetricsCopyWith<$Res> {
  factory $HealthMetricsCopyWith(
          HealthMetrics value, $Res Function(HealthMetrics) then) =
      _$HealthMetricsCopyWithImpl<$Res, HealthMetrics>;
  @useResult
  $Res call(
      {double utilization,
      double coverage,
      int pendingClaimsCount,
      String totalPendingWithFees});
}

/// @nodoc
class _$HealthMetricsCopyWithImpl<$Res, $Val extends HealthMetrics>
    implements $HealthMetricsCopyWith<$Res> {
  _$HealthMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? utilization = null,
    Object? coverage = null,
    Object? pendingClaimsCount = null,
    Object? totalPendingWithFees = null,
  }) {
    return _then(_value.copyWith(
      utilization: null == utilization
          ? _value.utilization
          : utilization // ignore: cast_nullable_to_non_nullable
              as double,
      coverage: null == coverage
          ? _value.coverage
          : coverage // ignore: cast_nullable_to_non_nullable
              as double,
      pendingClaimsCount: null == pendingClaimsCount
          ? _value.pendingClaimsCount
          : pendingClaimsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPendingWithFees: null == totalPendingWithFees
          ? _value.totalPendingWithFees
          : totalPendingWithFees // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthMetricsImplCopyWith<$Res>
    implements $HealthMetricsCopyWith<$Res> {
  factory _$$HealthMetricsImplCopyWith(
          _$HealthMetricsImpl value, $Res Function(_$HealthMetricsImpl) then) =
      __$$HealthMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double utilization,
      double coverage,
      int pendingClaimsCount,
      String totalPendingWithFees});
}

/// @nodoc
class __$$HealthMetricsImplCopyWithImpl<$Res>
    extends _$HealthMetricsCopyWithImpl<$Res, _$HealthMetricsImpl>
    implements _$$HealthMetricsImplCopyWith<$Res> {
  __$$HealthMetricsImplCopyWithImpl(
      _$HealthMetricsImpl _value, $Res Function(_$HealthMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? utilization = null,
    Object? coverage = null,
    Object? pendingClaimsCount = null,
    Object? totalPendingWithFees = null,
  }) {
    return _then(_$HealthMetricsImpl(
      utilization: null == utilization
          ? _value.utilization
          : utilization // ignore: cast_nullable_to_non_nullable
              as double,
      coverage: null == coverage
          ? _value.coverage
          : coverage // ignore: cast_nullable_to_non_nullable
              as double,
      pendingClaimsCount: null == pendingClaimsCount
          ? _value.pendingClaimsCount
          : pendingClaimsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPendingWithFees: null == totalPendingWithFees
          ? _value.totalPendingWithFees
          : totalPendingWithFees // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthMetricsImpl implements _HealthMetrics {
  const _$HealthMetricsImpl(
      {required this.utilization,
      required this.coverage,
      required this.pendingClaimsCount,
      required this.totalPendingWithFees});

  factory _$HealthMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthMetricsImplFromJson(json);

  @override
  final double utilization;
  @override
  final double coverage;
  @override
  final int pendingClaimsCount;
  @override
  final String totalPendingWithFees;

  @override
  String toString() {
    return 'HealthMetrics(utilization: $utilization, coverage: $coverage, pendingClaimsCount: $pendingClaimsCount, totalPendingWithFees: $totalPendingWithFees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthMetricsImpl &&
            (identical(other.utilization, utilization) ||
                other.utilization == utilization) &&
            (identical(other.coverage, coverage) ||
                other.coverage == coverage) &&
            (identical(other.pendingClaimsCount, pendingClaimsCount) ||
                other.pendingClaimsCount == pendingClaimsCount) &&
            (identical(other.totalPendingWithFees, totalPendingWithFees) ||
                other.totalPendingWithFees == totalPendingWithFees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, utilization, coverage,
      pendingClaimsCount, totalPendingWithFees);

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthMetricsImplCopyWith<_$HealthMetricsImpl> get copyWith =>
      __$$HealthMetricsImplCopyWithImpl<_$HealthMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthMetricsImplToJson(
      this,
    );
  }
}

abstract class _HealthMetrics implements HealthMetrics {
  const factory _HealthMetrics(
      {required final double utilization,
      required final double coverage,
      required final int pendingClaimsCount,
      required final String totalPendingWithFees}) = _$HealthMetricsImpl;

  factory _HealthMetrics.fromJson(Map<String, dynamic> json) =
      _$HealthMetricsImpl.fromJson;

  @override
  double get utilization;
  @override
  double get coverage;
  @override
  int get pendingClaimsCount;
  @override
  String get totalPendingWithFees;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthMetricsImplCopyWith<_$HealthMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MaxWithdrawal _$MaxWithdrawalFromJson(Map<String, dynamic> json) {
  return _MaxWithdrawal.fromJson(json);
}

/// @nodoc
mixin _$MaxWithdrawal {
  String get maxSafeWithdrawal => throw _privateConstructorUsedError;
  String get safetyBuffer => throw _privateConstructorUsedError;
  String get currentBalance => throw _privateConstructorUsedError;
  String get pendingClaims => throw _privateConstructorUsedError;
  int get pendingClaimsCount => throw _privateConstructorUsedError;

  /// Serializes this MaxWithdrawal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaxWithdrawal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaxWithdrawalCopyWith<MaxWithdrawal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaxWithdrawalCopyWith<$Res> {
  factory $MaxWithdrawalCopyWith(
          MaxWithdrawal value, $Res Function(MaxWithdrawal) then) =
      _$MaxWithdrawalCopyWithImpl<$Res, MaxWithdrawal>;
  @useResult
  $Res call(
      {String maxSafeWithdrawal,
      String safetyBuffer,
      String currentBalance,
      String pendingClaims,
      int pendingClaimsCount});
}

/// @nodoc
class _$MaxWithdrawalCopyWithImpl<$Res, $Val extends MaxWithdrawal>
    implements $MaxWithdrawalCopyWith<$Res> {
  _$MaxWithdrawalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaxWithdrawal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSafeWithdrawal = null,
    Object? safetyBuffer = null,
    Object? currentBalance = null,
    Object? pendingClaims = null,
    Object? pendingClaimsCount = null,
  }) {
    return _then(_value.copyWith(
      maxSafeWithdrawal: null == maxSafeWithdrawal
          ? _value.maxSafeWithdrawal
          : maxSafeWithdrawal // ignore: cast_nullable_to_non_nullable
              as String,
      safetyBuffer: null == safetyBuffer
          ? _value.safetyBuffer
          : safetyBuffer // ignore: cast_nullable_to_non_nullable
              as String,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as String,
      pendingClaims: null == pendingClaims
          ? _value.pendingClaims
          : pendingClaims // ignore: cast_nullable_to_non_nullable
              as String,
      pendingClaimsCount: null == pendingClaimsCount
          ? _value.pendingClaimsCount
          : pendingClaimsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MaxWithdrawalImplCopyWith<$Res>
    implements $MaxWithdrawalCopyWith<$Res> {
  factory _$$MaxWithdrawalImplCopyWith(
          _$MaxWithdrawalImpl value, $Res Function(_$MaxWithdrawalImpl) then) =
      __$$MaxWithdrawalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String maxSafeWithdrawal,
      String safetyBuffer,
      String currentBalance,
      String pendingClaims,
      int pendingClaimsCount});
}

/// @nodoc
class __$$MaxWithdrawalImplCopyWithImpl<$Res>
    extends _$MaxWithdrawalCopyWithImpl<$Res, _$MaxWithdrawalImpl>
    implements _$$MaxWithdrawalImplCopyWith<$Res> {
  __$$MaxWithdrawalImplCopyWithImpl(
      _$MaxWithdrawalImpl _value, $Res Function(_$MaxWithdrawalImpl) _then)
      : super(_value, _then);

  /// Create a copy of MaxWithdrawal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSafeWithdrawal = null,
    Object? safetyBuffer = null,
    Object? currentBalance = null,
    Object? pendingClaims = null,
    Object? pendingClaimsCount = null,
  }) {
    return _then(_$MaxWithdrawalImpl(
      maxSafeWithdrawal: null == maxSafeWithdrawal
          ? _value.maxSafeWithdrawal
          : maxSafeWithdrawal // ignore: cast_nullable_to_non_nullable
              as String,
      safetyBuffer: null == safetyBuffer
          ? _value.safetyBuffer
          : safetyBuffer // ignore: cast_nullable_to_non_nullable
              as String,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as String,
      pendingClaims: null == pendingClaims
          ? _value.pendingClaims
          : pendingClaims // ignore: cast_nullable_to_non_nullable
              as String,
      pendingClaimsCount: null == pendingClaimsCount
          ? _value.pendingClaimsCount
          : pendingClaimsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MaxWithdrawalImpl implements _MaxWithdrawal {
  const _$MaxWithdrawalImpl(
      {required this.maxSafeWithdrawal,
      required this.safetyBuffer,
      required this.currentBalance,
      required this.pendingClaims,
      required this.pendingClaimsCount});

  factory _$MaxWithdrawalImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaxWithdrawalImplFromJson(json);

  @override
  final String maxSafeWithdrawal;
  @override
  final String safetyBuffer;
  @override
  final String currentBalance;
  @override
  final String pendingClaims;
  @override
  final int pendingClaimsCount;

  @override
  String toString() {
    return 'MaxWithdrawal(maxSafeWithdrawal: $maxSafeWithdrawal, safetyBuffer: $safetyBuffer, currentBalance: $currentBalance, pendingClaims: $pendingClaims, pendingClaimsCount: $pendingClaimsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaxWithdrawalImpl &&
            (identical(other.maxSafeWithdrawal, maxSafeWithdrawal) ||
                other.maxSafeWithdrawal == maxSafeWithdrawal) &&
            (identical(other.safetyBuffer, safetyBuffer) ||
                other.safetyBuffer == safetyBuffer) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance) &&
            (identical(other.pendingClaims, pendingClaims) ||
                other.pendingClaims == pendingClaims) &&
            (identical(other.pendingClaimsCount, pendingClaimsCount) ||
                other.pendingClaimsCount == pendingClaimsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, maxSafeWithdrawal, safetyBuffer,
      currentBalance, pendingClaims, pendingClaimsCount);

  /// Create a copy of MaxWithdrawal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaxWithdrawalImplCopyWith<_$MaxWithdrawalImpl> get copyWith =>
      __$$MaxWithdrawalImplCopyWithImpl<_$MaxWithdrawalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaxWithdrawalImplToJson(
      this,
    );
  }
}

abstract class _MaxWithdrawal implements MaxWithdrawal {
  const factory _MaxWithdrawal(
      {required final String maxSafeWithdrawal,
      required final String safetyBuffer,
      required final String currentBalance,
      required final String pendingClaims,
      required final int pendingClaimsCount}) = _$MaxWithdrawalImpl;

  factory _MaxWithdrawal.fromJson(Map<String, dynamic> json) =
      _$MaxWithdrawalImpl.fromJson;

  @override
  String get maxSafeWithdrawal;
  @override
  String get safetyBuffer;
  @override
  String get currentBalance;
  @override
  String get pendingClaims;
  @override
  int get pendingClaimsCount;

  /// Create a copy of MaxWithdrawal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaxWithdrawalImplCopyWith<_$MaxWithdrawalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
