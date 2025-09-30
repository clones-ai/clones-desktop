import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'video_clip.freezed.dart';

@freezed
class VideoClip with _$VideoClip {
  const factory VideoClip({
    required String id,
    required double start,
    required double end,
    @Default(false) bool isSelected,
  }) = _VideoClip;

  const VideoClip._();

  factory VideoClip.create({
    required double start,
    required double end,
  }) {
    return VideoClip(
      id: const Uuid().v4(),
      start: start,
      end: end,
    );
  }

  double get duration => end - start;

  bool contains(double timeMs) => timeMs >= start && timeMs <= end;

  bool canSplitAt(double timeMs, {double minSegmentSize = 50.0}) {
    return contains(timeMs) && 
           (timeMs - start) > minSegmentSize && 
           (end - timeMs) > minSegmentSize;
  }

  (VideoClip left, VideoClip right) splitAt(double timeMs) {
    if (!canSplitAt(timeMs)) {
      throw ArgumentError('Cannot split clip at $timeMs');
    }
    
    return (
      VideoClip.create(start: start, end: timeMs),
      VideoClip.create(start: timeMs, end: end),
    );
  }

  RangeValues toRangeValues() => RangeValues(start, end);

  static VideoClip fromRangeValues(RangeValues range) {
    return VideoClip.create(start: range.start, end: range.end);
  }
}