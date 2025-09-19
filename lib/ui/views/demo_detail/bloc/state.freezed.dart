// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DemoDetailState {
  bool get isLoading => throw _privateConstructorUsedError;
  ApiRecording? get recording => throw _privateConstructorUsedError;
  List<RecordingEvent> get events => throw _privateConstructorUsedError;
  List<SftMessage> get sftMessages => throw _privateConstructorUsedError;
  List<DeletedRange> get privateRanges => throw _privateConstructorUsedError;
  Set<String> get eventTypes => throw _privateConstructorUsedError;
  Set<String> get enabledEventTypes => throw _privateConstructorUsedError;
  int get startTime => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  VideoPlayerController? get videoController =>
      throw _privateConstructorUsedError; // Video editing
  List<RangeValues> get deletedSegments => throw _privateConstructorUsedError;
  List<RangeValues> get clipSegments => throw _privateConstructorUsedError;
  Set<int> get selectedClipIndexes => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  RangeValues? get clipboardClip => throw _privateConstructorUsedError;
  bool get isApplyingEdits =>
      throw _privateConstructorUsedError; // New states for button handling
  bool get isProcessing => throw _privateConstructorUsedError;
  bool get isExporting => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  String? get exportPath => throw _privateConstructorUsedError;
  String? get exportError => throw _privateConstructorUsedError;
  String? get uploadError => throw _privateConstructorUsedError;

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemoDetailStateCopyWith<DemoDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemoDetailStateCopyWith<$Res> {
  factory $DemoDetailStateCopyWith(
          DemoDetailState value, $Res Function(DemoDetailState) then) =
      _$DemoDetailStateCopyWithImpl<$Res, DemoDetailState>;
  @useResult
  $Res call(
      {bool isLoading,
      ApiRecording? recording,
      List<RecordingEvent> events,
      List<SftMessage> sftMessages,
      List<DeletedRange> privateRanges,
      Set<String> eventTypes,
      Set<String> enabledEventTypes,
      int startTime,
      @JsonKey(includeIfNull: false) VideoPlayerController? videoController,
      List<RangeValues> deletedSegments,
      List<RangeValues> clipSegments,
      Set<int> selectedClipIndexes,
      @JsonKey(includeIfNull: false) RangeValues? clipboardClip,
      bool isApplyingEdits,
      bool isProcessing,
      bool isExporting,
      bool isUploading,
      String? exportPath,
      String? exportError,
      String? uploadError});

  $ApiRecordingCopyWith<$Res>? get recording;
}

/// @nodoc
class _$DemoDetailStateCopyWithImpl<$Res, $Val extends DemoDetailState>
    implements $DemoDetailStateCopyWith<$Res> {
  _$DemoDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? recording = freezed,
    Object? events = null,
    Object? sftMessages = null,
    Object? privateRanges = null,
    Object? eventTypes = null,
    Object? enabledEventTypes = null,
    Object? startTime = null,
    Object? videoController = freezed,
    Object? deletedSegments = null,
    Object? clipSegments = null,
    Object? selectedClipIndexes = null,
    Object? clipboardClip = freezed,
    Object? isApplyingEdits = null,
    Object? isProcessing = null,
    Object? isExporting = null,
    Object? isUploading = null,
    Object? exportPath = freezed,
    Object? exportError = freezed,
    Object? uploadError = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as ApiRecording?,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<RecordingEvent>,
      sftMessages: null == sftMessages
          ? _value.sftMessages
          : sftMessages // ignore: cast_nullable_to_non_nullable
              as List<SftMessage>,
      privateRanges: null == privateRanges
          ? _value.privateRanges
          : privateRanges // ignore: cast_nullable_to_non_nullable
              as List<DeletedRange>,
      eventTypes: null == eventTypes
          ? _value.eventTypes
          : eventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      enabledEventTypes: null == enabledEventTypes
          ? _value.enabledEventTypes
          : enabledEventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      videoController: freezed == videoController
          ? _value.videoController
          : videoController // ignore: cast_nullable_to_non_nullable
              as VideoPlayerController?,
      deletedSegments: null == deletedSegments
          ? _value.deletedSegments
          : deletedSegments // ignore: cast_nullable_to_non_nullable
              as List<RangeValues>,
      clipSegments: null == clipSegments
          ? _value.clipSegments
          : clipSegments // ignore: cast_nullable_to_non_nullable
              as List<RangeValues>,
      selectedClipIndexes: null == selectedClipIndexes
          ? _value.selectedClipIndexes
          : selectedClipIndexes // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      clipboardClip: freezed == clipboardClip
          ? _value.clipboardClip
          : clipboardClip // ignore: cast_nullable_to_non_nullable
              as RangeValues?,
      isApplyingEdits: null == isApplyingEdits
          ? _value.isApplyingEdits
          : isApplyingEdits // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _value.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      exportPath: freezed == exportPath
          ? _value.exportPath
          : exportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      exportError: freezed == exportError
          ? _value.exportError
          : exportError // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadError: freezed == uploadError
          ? _value.uploadError
          : uploadError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiRecordingCopyWith<$Res>? get recording {
    if (_value.recording == null) {
      return null;
    }

    return $ApiRecordingCopyWith<$Res>(_value.recording!, (value) {
      return _then(_value.copyWith(recording: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DemoDetailStateImplCopyWith<$Res>
    implements $DemoDetailStateCopyWith<$Res> {
  factory _$$DemoDetailStateImplCopyWith(_$DemoDetailStateImpl value,
          $Res Function(_$DemoDetailStateImpl) then) =
      __$$DemoDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      ApiRecording? recording,
      List<RecordingEvent> events,
      List<SftMessage> sftMessages,
      List<DeletedRange> privateRanges,
      Set<String> eventTypes,
      Set<String> enabledEventTypes,
      int startTime,
      @JsonKey(includeIfNull: false) VideoPlayerController? videoController,
      List<RangeValues> deletedSegments,
      List<RangeValues> clipSegments,
      Set<int> selectedClipIndexes,
      @JsonKey(includeIfNull: false) RangeValues? clipboardClip,
      bool isApplyingEdits,
      bool isProcessing,
      bool isExporting,
      bool isUploading,
      String? exportPath,
      String? exportError,
      String? uploadError});

  @override
  $ApiRecordingCopyWith<$Res>? get recording;
}

/// @nodoc
class __$$DemoDetailStateImplCopyWithImpl<$Res>
    extends _$DemoDetailStateCopyWithImpl<$Res, _$DemoDetailStateImpl>
    implements _$$DemoDetailStateImplCopyWith<$Res> {
  __$$DemoDetailStateImplCopyWithImpl(
      _$DemoDetailStateImpl _value, $Res Function(_$DemoDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? recording = freezed,
    Object? events = null,
    Object? sftMessages = null,
    Object? privateRanges = null,
    Object? eventTypes = null,
    Object? enabledEventTypes = null,
    Object? startTime = null,
    Object? videoController = freezed,
    Object? deletedSegments = null,
    Object? clipSegments = null,
    Object? selectedClipIndexes = null,
    Object? clipboardClip = freezed,
    Object? isApplyingEdits = null,
    Object? isProcessing = null,
    Object? isExporting = null,
    Object? isUploading = null,
    Object? exportPath = freezed,
    Object? exportError = freezed,
    Object? uploadError = freezed,
  }) {
    return _then(_$DemoDetailStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as ApiRecording?,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<RecordingEvent>,
      sftMessages: null == sftMessages
          ? _value._sftMessages
          : sftMessages // ignore: cast_nullable_to_non_nullable
              as List<SftMessage>,
      privateRanges: null == privateRanges
          ? _value._privateRanges
          : privateRanges // ignore: cast_nullable_to_non_nullable
              as List<DeletedRange>,
      eventTypes: null == eventTypes
          ? _value._eventTypes
          : eventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      enabledEventTypes: null == enabledEventTypes
          ? _value._enabledEventTypes
          : enabledEventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      videoController: freezed == videoController
          ? _value.videoController
          : videoController // ignore: cast_nullable_to_non_nullable
              as VideoPlayerController?,
      deletedSegments: null == deletedSegments
          ? _value._deletedSegments
          : deletedSegments // ignore: cast_nullable_to_non_nullable
              as List<RangeValues>,
      clipSegments: null == clipSegments
          ? _value._clipSegments
          : clipSegments // ignore: cast_nullable_to_non_nullable
              as List<RangeValues>,
      selectedClipIndexes: null == selectedClipIndexes
          ? _value._selectedClipIndexes
          : selectedClipIndexes // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      clipboardClip: freezed == clipboardClip
          ? _value.clipboardClip
          : clipboardClip // ignore: cast_nullable_to_non_nullable
              as RangeValues?,
      isApplyingEdits: null == isApplyingEdits
          ? _value.isApplyingEdits
          : isApplyingEdits // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _value.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      exportPath: freezed == exportPath
          ? _value.exportPath
          : exportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      exportError: freezed == exportError
          ? _value.exportError
          : exportError // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadError: freezed == uploadError
          ? _value.uploadError
          : uploadError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DemoDetailStateImpl extends _DemoDetailState {
  const _$DemoDetailStateImpl(
      {this.isLoading = false,
      this.recording,
      final List<RecordingEvent> events = const [],
      final List<SftMessage> sftMessages = const [],
      final List<DeletedRange> privateRanges = const [],
      final Set<String> eventTypes = const {},
      final Set<String> enabledEventTypes = const {},
      this.startTime = 0,
      @JsonKey(includeIfNull: false) this.videoController,
      final List<RangeValues> deletedSegments = const [],
      final List<RangeValues> clipSegments = const [],
      final Set<int> selectedClipIndexes = const {},
      @JsonKey(includeIfNull: false) this.clipboardClip,
      this.isApplyingEdits = false,
      this.isProcessing = false,
      this.isExporting = false,
      this.isUploading = false,
      this.exportPath,
      this.exportError,
      this.uploadError})
      : _events = events,
        _sftMessages = sftMessages,
        _privateRanges = privateRanges,
        _eventTypes = eventTypes,
        _enabledEventTypes = enabledEventTypes,
        _deletedSegments = deletedSegments,
        _clipSegments = clipSegments,
        _selectedClipIndexes = selectedClipIndexes,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final ApiRecording? recording;
  final List<RecordingEvent> _events;
  @override
  @JsonKey()
  List<RecordingEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  final List<SftMessage> _sftMessages;
  @override
  @JsonKey()
  List<SftMessage> get sftMessages {
    if (_sftMessages is EqualUnmodifiableListView) return _sftMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sftMessages);
  }

  final List<DeletedRange> _privateRanges;
  @override
  @JsonKey()
  List<DeletedRange> get privateRanges {
    if (_privateRanges is EqualUnmodifiableListView) return _privateRanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_privateRanges);
  }

  final Set<String> _eventTypes;
  @override
  @JsonKey()
  Set<String> get eventTypes {
    if (_eventTypes is EqualUnmodifiableSetView) return _eventTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_eventTypes);
  }

  final Set<String> _enabledEventTypes;
  @override
  @JsonKey()
  Set<String> get enabledEventTypes {
    if (_enabledEventTypes is EqualUnmodifiableSetView)
      return _enabledEventTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_enabledEventTypes);
  }

  @override
  @JsonKey()
  final int startTime;
  @override
  @JsonKey(includeIfNull: false)
  final VideoPlayerController? videoController;
// Video editing
  final List<RangeValues> _deletedSegments;
// Video editing
  @override
  @JsonKey()
  List<RangeValues> get deletedSegments {
    if (_deletedSegments is EqualUnmodifiableListView) return _deletedSegments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deletedSegments);
  }

  final List<RangeValues> _clipSegments;
  @override
  @JsonKey()
  List<RangeValues> get clipSegments {
    if (_clipSegments is EqualUnmodifiableListView) return _clipSegments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clipSegments);
  }

  final Set<int> _selectedClipIndexes;
  @override
  @JsonKey()
  Set<int> get selectedClipIndexes {
    if (_selectedClipIndexes is EqualUnmodifiableSetView)
      return _selectedClipIndexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedClipIndexes);
  }

  @override
  @JsonKey(includeIfNull: false)
  final RangeValues? clipboardClip;
  @override
  @JsonKey()
  final bool isApplyingEdits;
// New states for button handling
  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final bool isExporting;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  final String? exportPath;
  @override
  final String? exportError;
  @override
  final String? uploadError;

  @override
  String toString() {
    return 'DemoDetailState(isLoading: $isLoading, recording: $recording, events: $events, sftMessages: $sftMessages, privateRanges: $privateRanges, eventTypes: $eventTypes, enabledEventTypes: $enabledEventTypes, startTime: $startTime, videoController: $videoController, deletedSegments: $deletedSegments, clipSegments: $clipSegments, selectedClipIndexes: $selectedClipIndexes, clipboardClip: $clipboardClip, isApplyingEdits: $isApplyingEdits, isProcessing: $isProcessing, isExporting: $isExporting, isUploading: $isUploading, exportPath: $exportPath, exportError: $exportError, uploadError: $uploadError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemoDetailStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.recording, recording) ||
                other.recording == recording) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._sftMessages, _sftMessages) &&
            const DeepCollectionEquality()
                .equals(other._privateRanges, _privateRanges) &&
            const DeepCollectionEquality()
                .equals(other._eventTypes, _eventTypes) &&
            const DeepCollectionEquality()
                .equals(other._enabledEventTypes, _enabledEventTypes) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.videoController, videoController) ||
                other.videoController == videoController) &&
            const DeepCollectionEquality()
                .equals(other._deletedSegments, _deletedSegments) &&
            const DeepCollectionEquality()
                .equals(other._clipSegments, _clipSegments) &&
            const DeepCollectionEquality()
                .equals(other._selectedClipIndexes, _selectedClipIndexes) &&
            (identical(other.clipboardClip, clipboardClip) ||
                other.clipboardClip == clipboardClip) &&
            (identical(other.isApplyingEdits, isApplyingEdits) ||
                other.isApplyingEdits == isApplyingEdits) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.exportPath, exportPath) ||
                other.exportPath == exportPath) &&
            (identical(other.exportError, exportError) ||
                other.exportError == exportError) &&
            (identical(other.uploadError, uploadError) ||
                other.uploadError == uploadError));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isLoading,
        recording,
        const DeepCollectionEquality().hash(_events),
        const DeepCollectionEquality().hash(_sftMessages),
        const DeepCollectionEquality().hash(_privateRanges),
        const DeepCollectionEquality().hash(_eventTypes),
        const DeepCollectionEquality().hash(_enabledEventTypes),
        startTime,
        videoController,
        const DeepCollectionEquality().hash(_deletedSegments),
        const DeepCollectionEquality().hash(_clipSegments),
        const DeepCollectionEquality().hash(_selectedClipIndexes),
        clipboardClip,
        isApplyingEdits,
        isProcessing,
        isExporting,
        isUploading,
        exportPath,
        exportError,
        uploadError
      ]);

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemoDetailStateImplCopyWith<_$DemoDetailStateImpl> get copyWith =>
      __$$DemoDetailStateImplCopyWithImpl<_$DemoDetailStateImpl>(
          this, _$identity);
}

abstract class _DemoDetailState extends DemoDetailState {
  const factory _DemoDetailState(
      {final bool isLoading,
      final ApiRecording? recording,
      final List<RecordingEvent> events,
      final List<SftMessage> sftMessages,
      final List<DeletedRange> privateRanges,
      final Set<String> eventTypes,
      final Set<String> enabledEventTypes,
      final int startTime,
      @JsonKey(includeIfNull: false)
      final VideoPlayerController? videoController,
      final List<RangeValues> deletedSegments,
      final List<RangeValues> clipSegments,
      final Set<int> selectedClipIndexes,
      @JsonKey(includeIfNull: false) final RangeValues? clipboardClip,
      final bool isApplyingEdits,
      final bool isProcessing,
      final bool isExporting,
      final bool isUploading,
      final String? exportPath,
      final String? exportError,
      final String? uploadError}) = _$DemoDetailStateImpl;
  const _DemoDetailState._() : super._();

  @override
  bool get isLoading;
  @override
  ApiRecording? get recording;
  @override
  List<RecordingEvent> get events;
  @override
  List<SftMessage> get sftMessages;
  @override
  List<DeletedRange> get privateRanges;
  @override
  Set<String> get eventTypes;
  @override
  Set<String> get enabledEventTypes;
  @override
  int get startTime;
  @override
  @JsonKey(includeIfNull: false)
  VideoPlayerController? get videoController; // Video editing
  @override
  List<RangeValues> get deletedSegments;
  @override
  List<RangeValues> get clipSegments;
  @override
  Set<int> get selectedClipIndexes;
  @override
  @JsonKey(includeIfNull: false)
  RangeValues? get clipboardClip;
  @override
  bool get isApplyingEdits; // New states for button handling
  @override
  bool get isProcessing;
  @override
  bool get isExporting;
  @override
  bool get isUploading;
  @override
  String? get exportPath;
  @override
  String? get exportError;
  @override
  String? get uploadError;

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemoDetailStateImplCopyWith<_$DemoDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
