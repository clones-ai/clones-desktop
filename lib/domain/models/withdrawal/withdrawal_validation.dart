import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_validation.freezed.dart';
part 'withdrawal_validation.g.dart';

/// Validation result for a withdrawal request
@freezed
class WithdrawalValidation with _$WithdrawalValidation {
  const factory WithdrawalValidation({
    required bool allowed,
    String? reason,
    required String maxSafeWithdrawal,
    String? safetyBuffer,
    required PoolState poolState,
  }) = _WithdrawalValidation;

  factory WithdrawalValidation.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalValidationFromJson(json);
}

/// Pool state including pending claims and allocations
@freezed
class PoolState with _$PoolState {
  const factory PoolState({
    required String address,
    required String creator,
    required String token,
    required String balance,
    required String totalAllocated,
    required String totalClaimed,
    required String totalPending,
    required int allocationCount,
    required List<PoolAllocation> allocations,
  }) = _PoolState;

  factory PoolState.fromJson(Map<String, dynamic> json) =>
      _$PoolStateFromJson(json);
}

/// Individual farmer allocation in a pool
@freezed
class PoolAllocation with _$PoolAllocation {
  const factory PoolAllocation({
    required String farmerAddress,
    required String cumulativeAmount,
    required String alreadyClaimed,
    required String pendingAmount,
  }) = _PoolAllocation;

  factory PoolAllocation.fromJson(Map<String, dynamic> json) =>
      _$PoolAllocationFromJson(json);
}

/// Pool health metrics and alerts
@freezed
class PoolHealth with _$PoolHealth {
  const factory PoolHealth({
    required String poolAddress,
    required bool healthy,
    required List<String> alerts,
    required HealthMetrics metrics,
    required PoolState state,
  }) = _PoolHealth;

  factory PoolHealth.fromJson(Map<String, dynamic> json) =>
      _$PoolHealthFromJson(json);
}

/// Health metrics for a pool
@freezed
class HealthMetrics with _$HealthMetrics {
  const factory HealthMetrics({
    required double utilization,
    required double coverage,
    required int pendingClaimsCount,
    required String totalPendingWithFees,
  }) = _HealthMetrics;

  factory HealthMetrics.fromJson(Map<String, dynamic> json) =>
      _$HealthMetricsFromJson(json);
}

/// Maximum safe withdrawal calculation
@freezed
class MaxWithdrawal with _$MaxWithdrawal {
  const factory MaxWithdrawal({
    required String maxSafeWithdrawal,
    required String safetyBuffer,
    required String currentBalance,
    required String pendingClaims,
    required int pendingClaimsCount,
  }) = _MaxWithdrawal;

  factory MaxWithdrawal.fromJson(Map<String, dynamic> json) =>
      _$MaxWithdrawalFromJson(json);
}
