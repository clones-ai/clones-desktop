import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class ForgeState with _$ForgeState {
  const factory ForgeState({
    @Default(false) bool showGenerateFactoryModal,
  }) = _ForgeState;
  const ForgeState._();
}
