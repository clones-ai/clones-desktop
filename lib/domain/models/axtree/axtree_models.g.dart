// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'axtree_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AxTreeBboxImpl _$$AxTreeBboxImplFromJson(Map<String, dynamic> json) =>
    _$AxTreeBboxImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$$AxTreeBboxImplToJson(_$AxTreeBboxImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
    };

_$AxTreeStatesImpl _$$AxTreeStatesImplFromJson(Map<String, dynamic> json) =>
    _$AxTreeStatesImpl(
      enabled: json['enabled'] as bool? ?? false,
      visible: json['visible'] as bool? ?? false,
      keyboardFocusable: json['keyboard_focusable'] as bool? ?? false,
    );

Map<String, dynamic> _$$AxTreeStatesImplToJson(_$AxTreeStatesImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'visible': instance.visible,
      'keyboard_focusable': instance.keyboardFocusable,
    };

_$AxTreeElementImpl _$$AxTreeElementImplFromJson(Map<String, dynamic> json) =>
    _$AxTreeElementImpl(
      bbox: json['bbox'] == null
          ? null
          : AxTreeBbox.fromJson(json['bbox'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => AxTreeElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      states: json['states'] == null
          ? null
          : AxTreeStates.fromJson(json['states'] as Map<String, dynamic>),
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$$AxTreeElementImplToJson(_$AxTreeElementImpl instance) =>
    <String, dynamic>{
      'bbox': instance.bbox,
      'children': instance.children,
      'description': instance.description,
      'name': instance.name,
      'role': instance.role,
      'states': instance.states,
      'value': instance.value,
    };

_$AxTreePositionImpl _$$AxTreePositionImplFromJson(Map<String, dynamic> json) =>
    _$AxTreePositionImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$AxTreePositionImplToJson(
        _$AxTreePositionImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

_$AxTreeQueryImpl _$$AxTreeQueryImplFromJson(Map<String, dynamic> json) =>
    _$AxTreeQueryImpl(
      element: json['element'] == null
          ? null
          : AxTreeElement.fromJson(json['element'] as Map<String, dynamic>),
      position: json['position'] == null
          ? null
          : AxTreePosition.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AxTreeQueryImplToJson(_$AxTreeQueryImpl instance) =>
    <String, dynamic>{
      'element': instance.element,
      'position': instance.position,
    };

_$AxTreeDataImpl _$$AxTreeDataImplFromJson(Map<String, dynamic> json) =>
    _$AxTreeDataImpl(
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      focusedElement: json['focused_element'] == null
          ? null
          : AxTreeElement.fromJson(
              json['focused_element'] as Map<String, dynamic>),
      queries: (json['queries'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, AxTreeQuery.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      tree: (json['tree'] as List<dynamic>?)
              ?.map((e) => AxTreeElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AxTreeDataImplToJson(_$AxTreeDataImpl instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'focused_element': instance.focusedElement,
      'queries': instance.queries,
      'tree': instance.tree,
    };

_$AxTreeEventImpl _$$AxTreeEventImplFromJson(Map<String, dynamic> json) =>
    _$AxTreeEventImpl(
      event: json['event'] as String? ?? 'axtree',
      data: AxTreeData.fromJson(json['data'] as Map<String, dynamic>),
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$$AxTreeEventImplToJson(_$AxTreeEventImpl instance) =>
    <String, dynamic>{
      'event': instance.event,
      'data': instance.data,
      'time': instance.time,
    };
