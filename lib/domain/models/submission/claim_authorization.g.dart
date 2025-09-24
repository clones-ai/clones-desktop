// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClaimAuthorizationImpl _$$ClaimAuthorizationImplFromJson(
        Map<String, dynamic> json) =>
    _$ClaimAuthorizationImpl(
      account: json['account'] as String,
      cumulativeAmount: json['cumulativeAmount'] as String,
      deadline: (json['deadline'] as num?)?.toInt(),
      signature: json['signature'] as String,
      publisherUsed: json['publisherUsed'] as String,
      poolAddress: json['poolAddress'] as String,
      tokenAddress: json['tokenAddress'] as String,
    );

Map<String, dynamic> _$$ClaimAuthorizationImplToJson(
        _$ClaimAuthorizationImpl instance) =>
    <String, dynamic>{
      'account': instance.account,
      'cumulativeAmount': instance.cumulativeAmount,
      'deadline': instance.deadline,
      'signature': instance.signature,
      'publisherUsed': instance.publisherUsed,
      'poolAddress': instance.poolAddress,
      'tokenAddress': instance.tokenAddress,
    };
