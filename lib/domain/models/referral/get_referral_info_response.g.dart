// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_referral_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetReferralInfoResponseImpl _$$GetReferralInfoResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetReferralInfoResponseImpl(
      walletAddress: json['walletAddress'] as String,
      referralCode: json['referralCode'] as String,
      isActive: json['isActive'] as bool,
      totalReferrals: (json['totalReferrals'] as num).toInt(),
      totalRewards: (json['totalRewards'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      referrals: (json['referrals'] as List<dynamic>)
          .map((e) => Referral.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetReferralInfoResponseImplToJson(
        _$GetReferralInfoResponseImpl instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'referralCode': instance.referralCode,
      'isActive': instance.isActive,
      'totalReferrals': instance.totalReferrals,
      'totalRewards': instance.totalRewards,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'referrals': instance.referrals,
    };
