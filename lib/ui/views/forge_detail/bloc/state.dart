import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum ViewModeTasks {
  edit,
  preview,
}

@freezed
class ForgeDetailState with _$ForgeDetailState {
  const factory ForgeDetailState({
    @Default('') String factoryName,
    @Default(1) double pricePerDemo,
    @Default(10) int uploadLimitValue,
    @Default('none') String uploadLimitType,
    @Default(FactoryStatus.error) FactoryStatus? factoryStatus,
    Factory? factory,
    @Default(ViewModeTasks.edit) ViewModeTasks viewModeTasks,
    String? error,
    @Default([]) List<FactoryApp> apps,
    @Default(false) bool isUpdateFactoryStatusSuccess,
    @Default(false) bool isUpdatePoolSuccess,
    @Default(false) bool isRefreshBalanceSuccess,
    @Default(false) bool hasUnsavedChanges,
    @Default(false) bool showNewAppForm,
    @Default(false) bool showManageTaskModal,
    @Default(ManageTaskModalType.create)
    ManageTaskModalType manageTaskModalType,
    String? newAppName,
    String? newAppDomain,
    int? editingTaskAppIdx,
    int? editingTaskIdx,
  }) = _ForgeDetailState;
  const ForgeDetailState._();
}
