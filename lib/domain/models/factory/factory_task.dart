// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'factory_task.freezed.dart';
part 'factory_task.g.dart';

/// Factory task definition
@freezed
class FactoryTask with _$FactoryTask {
  const factory FactoryTask({
    String? id,
    required String prompt,
    int? uploadLimit,
    double? rewardLimit,
    String? limitReason,
  }) = _FactoryTask;

  factory FactoryTask.fromJson(Map<String, dynamic> json) =>
      _$FactoryTaskFromJson(json);
}
