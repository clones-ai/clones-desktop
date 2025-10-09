// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_chain_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnChainRewardImpl _$$OnChainRewardImplFromJson(Map<String, dynamic> json) =>
    _$OnChainRewardImpl(
      tokenAddress: json['tokenAddress'] as String,
      poolAddress: json['poolAddress'] as String,
      amount: (json['amount'] as num).toDouble(),
      grossAmount: (json['grossAmount'] as num?)?.toDouble(),
      feeAmount: (json['feeAmount'] as num?)?.toDouble(),
      netAmount: (json['netAmount'] as num?)?.toDouble(),
      submissionId: json['submissionId'] as String?,
      txHash: json['txHash'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      cumulativeAmount: (json['cumulativeAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$OnChainRewardImplToJson(_$OnChainRewardImpl instance) =>
    <String, dynamic>{
      'tokenAddress': instance.tokenAddress,
      'poolAddress': instance.poolAddress,
      'amount': instance.amount,
      'grossAmount': instance.grossAmount,
      'feeAmount': instance.feeAmount,
      'netAmount': instance.netAmount,
      'submissionId': instance.submissionId,
      'txHash': instance.txHash,
      'timestamp': instance.timestamp,
      'cumulativeAmount': instance.cumulativeAmount,
    };
