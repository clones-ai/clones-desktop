import 'package:clones/domain/models/upload/upload_limit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum ManageTaskModalType {
  create,
  edit,
}

@freezed
class ManageTaskState with _$ManageTaskState {
  const factory ManageTaskState({
    @Default(ManageTaskModalType.create) ManageTaskModalType modalType,
    @Default('') String prompt,
    @Default(1) double pricePerDemo,
    @Default(10) int uploadLimitValue,
    @Default(UploadLimitType.perTask) UploadLimitType uploadLimitType,
  }) = _ManageTaskState;
  const ManageTaskState._();
}
