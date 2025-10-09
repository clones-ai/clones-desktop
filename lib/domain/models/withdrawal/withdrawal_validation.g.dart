// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_validation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WithdrawalValidationImpl _$$WithdrawalValidationImplFromJson(
        Map<String, dynamic> json) =>
    _$WithdrawalValidationImpl(
      allowed: json['allowed'] as bool,
      reason: json['reason'] as String?,
      maxSafeWithdrawal: json['maxSafeWithdrawal'] as String,
      safetyBuffer: json['safetyBuffer'] as String?,
      poolState: PoolState.fromJson(json['poolState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WithdrawalValidationImplToJson(
        _$WithdrawalValidationImpl instance) =>
    <String, dynamic>{
      'allowed': instance.allowed,
      'reason': instance.reason,
      'maxSafeWithdrawal': instance.maxSafeWithdrawal,
      'safetyBuffer': instance.safetyBuffer,
      'poolState': instance.poolState,
    };

_$PoolStateImpl _$$PoolStateImplFromJson(Map<String, dynamic> json) =>
    _$PoolStateImpl(
      address: json['address'] as String,
      creator: json['creator'] as String,
      token: json['token'] as String,
      balance: json['balance'] as String,
      totalAllocated: json['totalAllocated'] as String,
      totalClaimed: json['totalClaimed'] as String,
      totalPending: json['totalPending'] as String,
      allocationCount: (json['allocationCount'] as num).toInt(),
      allocations: (json['allocations'] as List<dynamic>)
          .map((e) => PoolAllocation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PoolStateImplToJson(_$PoolStateImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'creator': instance.creator,
      'token': instance.token,
      'balance': instance.balance,
      'totalAllocated': instance.totalAllocated,
      'totalClaimed': instance.totalClaimed,
      'totalPending': instance.totalPending,
      'allocationCount': instance.allocationCount,
      'allocations': instance.allocations,
    };

_$PoolAllocationImpl _$$PoolAllocationImplFromJson(Map<String, dynamic> json) =>
    _$PoolAllocationImpl(
      farmerAddress: json['farmerAddress'] as String,
      cumulativeAmount: json['cumulativeAmount'] as String,
      alreadyClaimed: json['alreadyClaimed'] as String,
      pendingAmount: json['pendingAmount'] as String,
    );

Map<String, dynamic> _$$PoolAllocationImplToJson(
        _$PoolAllocationImpl instance) =>
    <String, dynamic>{
      'farmerAddress': instance.farmerAddress,
      'cumulativeAmount': instance.cumulativeAmount,
      'alreadyClaimed': instance.alreadyClaimed,
      'pendingAmount': instance.pendingAmount,
    };

_$PoolHealthImpl _$$PoolHealthImplFromJson(Map<String, dynamic> json) =>
    _$PoolHealthImpl(
      poolAddress: json['poolAddress'] as String,
      healthy: json['healthy'] as bool,
      alerts:
          (json['alerts'] as List<dynamic>).map((e) => e as String).toList(),
      metrics: HealthMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
      state: PoolState.fromJson(json['state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PoolHealthImplToJson(_$PoolHealthImpl instance) =>
    <String, dynamic>{
      'poolAddress': instance.poolAddress,
      'healthy': instance.healthy,
      'alerts': instance.alerts,
      'metrics': instance.metrics,
      'state': instance.state,
    };

_$HealthMetricsImpl _$$HealthMetricsImplFromJson(Map<String, dynamic> json) =>
    _$HealthMetricsImpl(
      utilization: (json['utilization'] as num).toDouble(),
      coverage: (json['coverage'] as num).toDouble(),
      pendingClaimsCount: (json['pendingClaimsCount'] as num).toInt(),
      totalPendingWithFees: json['totalPendingWithFees'] as String,
    );

Map<String, dynamic> _$$HealthMetricsImplToJson(_$HealthMetricsImpl instance) =>
    <String, dynamic>{
      'utilization': instance.utilization,
      'coverage': instance.coverage,
      'pendingClaimsCount': instance.pendingClaimsCount,
      'totalPendingWithFees': instance.totalPendingWithFees,
    };

_$MaxWithdrawalImpl _$$MaxWithdrawalImplFromJson(Map<String, dynamic> json) =>
    _$MaxWithdrawalImpl(
      maxSafeWithdrawal: json['maxSafeWithdrawal'] as String,
      safetyBuffer: json['safetyBuffer'] as String,
      currentBalance: json['currentBalance'] as String,
      pendingClaims: json['pendingClaims'] as String,
      pendingClaimsCount: (json['pendingClaimsCount'] as num).toInt(),
    );

Map<String, dynamic> _$$MaxWithdrawalImplToJson(_$MaxWithdrawalImpl instance) =>
    <String, dynamic>{
      'maxSafeWithdrawal': instance.maxSafeWithdrawal,
      'safetyBuffer': instance.safetyBuffer,
      'currentBalance': instance.currentBalance,
      'pendingClaims': instance.pendingClaims,
      'pendingClaimsCount': instance.pendingClaimsCount,
    };
