import 'package:clones_desktop/application/referral.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/domain/models/api/api_error.dart';
import 'package:clones_desktop/domain/models/referral/referral_info.dart';
import 'package:clones_desktop/ui/views/referral/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ReferralNotifier extends _$ReferralNotifier {
  @override
  ReferralState build() {
    return const ReferralState();
  }

  void setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setErrorMessage(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  void setReferralInfo(ReferralInfo? referralInfo) {
    state = state.copyWith(referralInfo: referralInfo);
  }

  Future<void> createReferral() async {
    try {
      setIsLoading(true);
      final walletAddress = ref.read(sessionNotifierProvider).address;
      if (walletAddress == null) {
        setErrorMessage('Wallet address is null');
        setIsLoading(false);
        return;
      }

      final repository = ref.read(referralRepositoryProvider);
      final response = await repository.createReferral(walletAddress);

      final referralInfo = ReferralInfo(
        referralCode: response.referralCode,
        referralLink: response.referralLink,
        walletAddress: response.walletAddress,
        totalReferrals: 0,
        totalRewards: 0,
        isActive: true,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        referralInfo: referralInfo,
        showConfirmation: true,
      );
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> getReferralInfo(String walletAddress) async {
    try {
      setIsLoading(true);
      final referralInfo = await ref.read(
        getReferralInfoProvider(walletAddress).future,
      );

      if (referralInfo != null) {
        setReferralInfo(referralInfo);
      }
    } catch (e) {
      setReferralInfo(null);
      // Handle specific API errors
      if (e is ApiError) {
        // If it's a 404 error (wallet doesn't have referral code), show initial state instead of error
        if (e.status == 404) {
          state = state.copyWith(isLoading: false);
        } else {
          setErrorMessage(e.message);
        }
      } else {
        // Handle other types of exceptions
        setErrorMessage(e.toString());
      }
    } finally {
      setIsLoading(false);
    }
  }
}
