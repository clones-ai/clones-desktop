import 'package:freezed_annotation/freezed_annotation.dart';

part 'claim_authorization.freezed.dart';
part 'claim_authorization.g.dart';

/// EIP-712 claim authorization data for smart contract interaction
@freezed
class ClaimAuthorization with _$ClaimAuthorization {
  const factory ClaimAuthorization({
    /// Account address (farmer who can claim)
    required String account,

    /// Cumulative amount in wei (string to preserve precision)
    required String cumulativeAmount,

    /// Signature deadline (unix timestamp)
    int? deadline,

    /// EIP-712 signature for payWithSig()
    required String signature,

    /// Publisher address that signed this authorization
    required String publisherUsed,

    /// Pool contract address
    required String poolAddress,

    /// Token contract address
    required String tokenAddress,
  }) = _ClaimAuthorization;

  factory ClaimAuthorization.fromJson(Map<String, dynamic> json) =>
      _$ClaimAuthorizationFromJson(json);
}
