import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/withdrawal/withdrawal_validation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class FactoryWithdrawModalState with _$FactoryWithdrawModalState {
  const factory FactoryWithdrawModalState({
    Factory? factory,
    @Default(false) bool isShown,
    @Default('') String withdrawAmount,
    @Default(false) bool isLoading,
    @Default(false) bool isWithdrawing,
    String? estimatedGasCost,
    String? error,
    @Default(false) bool gasExceedsAmount,
    String? maxSafeWithdrawal,
    @Default(false) bool validationLoading,
    WithdrawalValidation? validationResult,
    PoolHealth? poolHealth,
  }) = _FactoryWithdrawModalState;
  const FactoryWithdrawModalState._();
}
