import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions.freezed.dart';

enum PermissionStatus {
  unknown,
  granted,
  denied,
  pending,
  restartRequired,
}

@freezed
class PermissionsData with _$PermissionsData {
  const factory PermissionsData({
    @Default(PermissionStatus.unknown) PermissionStatus accessibilityStatus,
    @Default(PermissionStatus.unknown) PermissionStatus screenRecordingStatus,
    @Default(true) bool isLoading,
  }) = _PermissionsData;

  const PermissionsData._();

  bool get accessibilityGranted =>
      accessibilityStatus == PermissionStatus.granted;
  bool get screenRecordingGranted =>
      screenRecordingStatus == PermissionStatus.granted;
  bool get allPermissionsGranted =>
      accessibilityGranted && screenRecordingGranted;
}
