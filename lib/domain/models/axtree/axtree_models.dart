import 'package:freezed_annotation/freezed_annotation.dart';

part 'axtree_models.freezed.dart';
part 'axtree_models.g.dart';

@freezed
class AxTreeBbox with _$AxTreeBbox {
  const factory AxTreeBbox({
    required double x,
    required double y,
    required double width,
    required double height,
  }) = _AxTreeBbox;

  factory AxTreeBbox.fromJson(Map<String, dynamic> json) =>
      _$AxTreeBboxFromJson(json);
}

@freezed
class AxTreeStates with _$AxTreeStates {
  const factory AxTreeStates({
    @Default(false) bool enabled,
    @Default(false) bool visible,
    @JsonKey(name: 'keyboard_focusable') @Default(false) bool keyboardFocusable,
  }) = _AxTreeStates;

  factory AxTreeStates.fromJson(Map<String, dynamic> json) =>
      _$AxTreeStatesFromJson(json);
}

@freezed
class AxTreeElement with _$AxTreeElement {
  const factory AxTreeElement({
    AxTreeBbox? bbox,
    @Default([]) List<AxTreeElement> children,
    @Default('') String description,
    @Default('') String name,
    @Default('') String role,
    AxTreeStates? states,
    @Default('') String value,
  }) = _AxTreeElement;

  factory AxTreeElement.fromJson(Map<String, dynamic> json) =>
      _$AxTreeElementFromJson(json);
}

@freezed
class AxTreePosition with _$AxTreePosition {
  const factory AxTreePosition({
    required double x,
    required double y,
  }) = _AxTreePosition;

  factory AxTreePosition.fromJson(Map<String, dynamic> json) =>
      _$AxTreePositionFromJson(json);
}

@freezed
class AxTreeQuery with _$AxTreeQuery {
  const factory AxTreeQuery({
    AxTreeElement? element,
    AxTreePosition? position,
  }) = _AxTreeQuery;

  factory AxTreeQuery.fromJson(Map<String, dynamic> json) =>
      _$AxTreeQueryFromJson(json);
}

@freezed
class AxTreeData with _$AxTreeData {
  const factory AxTreeData({
    @Default(0) int duration,
    @JsonKey(name: 'focused_element') AxTreeElement? focusedElement,
    @Default({}) Map<String, AxTreeQuery> queries,
    @Default([]) List<AxTreeElement> tree,
  }) = _AxTreeData;

  factory AxTreeData.fromJson(Map<String, dynamic> json) =>
      _$AxTreeDataFromJson(json);
}

@freezed
class AxTreeEvent with _$AxTreeEvent {
  const factory AxTreeEvent({
    @Default('axtree') String event,
    required AxTreeData data,
    required int time,
  }) = _AxTreeEvent;

  factory AxTreeEvent.fromJson(Map<String, dynamic> json) =>
      _$AxTreeEventFromJson(json);
}

/// Helper class to flatten the tree structure for overlay rendering
@freezed
class AxTreeBox with _$AxTreeBox {
  const factory AxTreeBox({
    required double x,
    required double y,
    required double width,
    required double height,
    required String name,
    required String role,
    @Default('') String description,
    @Default('') String value,
    @Default(false) bool isFocused,
  }) = _AxTreeBox;
}
