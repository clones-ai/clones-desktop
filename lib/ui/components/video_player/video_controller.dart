import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';

abstract class VideoController {
  Future<void> initialize();
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Future<void> setSpeed(double speed);
  void dispose();
}

class VideoControllerException implements Exception {
  final String message;
  final Object? originalException;

  VideoControllerException(this.message, [this.originalException]);

  @override
  String toString() => 'VideoControllerException: $message';
}

mixin VideoControllerMixin {
  static const Duration _initializationTimeout = Duration(seconds: 30);
  static const Duration _operationTimeout = Duration(seconds: 10);

  Future<T> _withTimeout<T>(
    Future<T> future,
    String operation, [
    Duration? timeout,
  ]) async {
    try {
      return await future.timeout(
        timeout ?? _operationTimeout,
        onTimeout: () => throw VideoControllerException(
          'Timeout during $operation after ${timeout?.inSeconds ?? _operationTimeout.inSeconds}s',
        ),
      );
    } catch (e) {
      if (e is VideoControllerException) rethrow;
      throw VideoControllerException(
          'Failed to $operation: ${e.toString()}', e);
    }
  }

  Future<T> withInitializationTimeout<T>(Future<T> future, String operation) {
    return _withTimeout(future, operation, _initializationTimeout);
  }

  Future<T> withOperationTimeout<T>(Future<T> future, String operation) {
    return _withTimeout(future, operation);
  }

  Future<void> safeExecute(
    Future<void> Function() operation,
    String operationName,
    dynamic ref, [
    String? videoId,
  ]) async {
    try {
      await operation();
    } catch (e) {
      final message = e is VideoControllerException
          ? e.message
          : 'Unexpected error during $operationName: ${e.toString()}';

      if (kDebugMode) {
        print('VideoController Error [$operationName]: $message');
        if (e is VideoControllerException && e.originalException != null) {
          print('Original exception: ${e.originalException}');
        }
      }

      // Only set error if videoId is provided (new scoped approach)
      if (videoId != null) {
        ref.read(videoStateNotifierProvider(videoId).notifier).setError(message);
      }
    }
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }
}

// Provider for creating video controllers based on source type
final videoControllerProvider = Provider.family<VideoController, VideoSource>(
  (ref, source) {
    if (kIsWeb) {
      return WebVideoController(source, ref);
    } else {
      return NativeVideoController(source, ref);
    }
  },
);

// We'll implement these in the respective platform files
class WebVideoController extends VideoController with VideoControllerMixin {
  final VideoSource source;
  final dynamic ref;

  WebVideoController(this.source, this.ref);

  @override
  Future<void> initialize() async {
    // Implementation will be in video_player_web.dart
    throw UnimplementedError();
  }

  @override
  Future<void> play() async {
    throw UnimplementedError();
  }

  @override
  Future<void> pause() async {
    throw UnimplementedError();
  }

  @override
  Future<void> stop() async {
    throw UnimplementedError();
  }

  @override
  Future<void> seekTo(Duration position) async {
    throw UnimplementedError();
  }

  @override
  Future<void> setSpeed(double speed) async {
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // Implementation will be in video_player_web.dart
  }
}

class NativeVideoController extends VideoController with VideoControllerMixin {
  final VideoSource source;
  final dynamic ref;

  NativeVideoController(this.source, this.ref);

  @override
  Future<void> initialize() async {
    // Implementation will be in video_player_native.dart
    throw UnimplementedError();
  }

  @override
  Future<void> play() async {
    throw UnimplementedError();
  }

  @override
  Future<void> pause() async {
    throw UnimplementedError();
  }

  @override
  Future<void> stop() async {
    throw UnimplementedError();
  }

  @override
  Future<void> seekTo(Duration position) async {
    throw UnimplementedError();
  }

  @override
  Future<void> setSpeed(double speed) async {
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // Implementation will be in video_player_native.dart
  }
}
