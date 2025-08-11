// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferralInfoImpl _$$ReferralInfoImplFromJson(Map<String, dynamic> json) =>
    _$ReferralInfoImpl(
      referralCode: json['referralCode'] as String,
      referralLink: json['referralLink'] as String?,
      walletAddress: json['walletAddress'] as String,
      totalReferrals: (json['totalReferrals'] as num).toInt(),
      totalRewards: (json['totalRewards'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$ReferralInfoImplToJson(_$ReferralInfoImpl instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'referralLink': instance.referralLink,
      'walletAddress': instance.walletAddress,
      'totalReferrals': instance.totalReferrals,
      'totalRewards': instance.totalRewards,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
