import 'dart:async';
import 'dart:io';

import 'package:clones_desktop/ui/components/video_player/video_controller.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart' as video_player;

class NativeVideoControllerImpl extends NativeVideoController {
  NativeVideoControllerImpl(super.source, super.ref);
  video_player.VideoPlayerController? _controller;
  StreamSubscription? _positionSubscription;
  Timer? _fallbackTimer;
  String? _tempFilePath;

  video_player.VideoPlayerController? get videoPlayerController => _controller;

  Future<video_player.VideoPlayerController>
      _createVideoControllerFromBase64() async {
    final base64Source = source as Base64VideoSource;
    final bytes = base64Source.videoBytes;

    // Create temporary file
    final tempDir = await getTemporaryDirectory();
    _tempFilePath =
        '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final tempFile = File(_tempFilePath!);
    await tempFile.writeAsBytes(bytes);

    return video_player.VideoPlayerController.file(
      tempFile,
      videoPlayerOptions: video_player.VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );
  }

  @override
  Future<void> initialize() async {
    try {
      ref
          .read(videoStateNotifierProvider.notifier)
          .setStatus(VideoPlayerStatus.loading);

      _controller = switch (source) {
        AssetVideoSource(path: final path) =>
          video_player.VideoPlayerController.asset(
            path,
            videoPlayerOptions: video_player.VideoPlayerOptions(
              mixWithOthers: false,
              allowBackgroundPlayback: false,
            ),
          ),
        FileVideoSource(path: final path) =>
          video_player.VideoPlayerController.file(
            File(path),
            videoPlayerOptions: video_player.VideoPlayerOptions(
              mixWithOthers: false,
              allowBackgroundPlayback: false,
            ),
          ),
        Base64VideoSource() => await _createVideoControllerFromBase64(),
      };

      // Fallback timer for initialization
      _fallbackTimer = Timer(const Duration(seconds: 35), () {
        if (_controller?.value.isInitialized != true) {
          throw VideoControllerException(
              'Video initialization timeout - fallback triggered');
        }
      });

      await withInitializationTimeout(
        _controller!.initialize(),
        'initialize native video controller',
      );

      _fallbackTimer?.cancel();

      final duration = _controller!.value.duration;
      ref.read(videoStateNotifierProvider.notifier).setReady(duration);

      // Setup position listener with throttling
      _positionSubscription =
          Stream.periodic(const Duration(milliseconds: 33)).listen((_) {
        if (_controller?.value.isInitialized == true) {
          final notifier = ref.read(videoStateNotifierProvider.notifier);
          notifier.updatePosition(_controller!.value.position);

          if (_controller!.value.isPlaying) {
            notifier.setPlaying();
          } else {
            notifier.setPaused();
          }

          notifier.setSpeed(_controller!.value.playbackSpeed);
        }
      });

      // Auto-play after initialization
      await play();
    } catch (e) {
      _fallbackTimer?.cancel();

      // Fallback: try to create a simple error state
      ref
          .read(videoStateNotifierProvider.notifier)
          .setError('Failed to initialize video: ${e.toString()}');

      // Graceful degradation - show error widget instead of crashing
      if (kDebugMode) {
        print(
            'Native video initialization failed, graceful degradation activated');
      }
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    if (_controller?.value.isInitialized == true) {
      await withOperationTimeout(
        _controller!.play(),
        'play video',
      );
      ref.read(videoStateNotifierProvider.notifier).setPlaying();
    } else {
      throw VideoControllerException('Cannot play: video not initialized');
    }
  }

  @override
  Future<void> pause() async {
    if (_controller?.value.isInitialized == true) {
      await withOperationTimeout(
        _controller!.pause(),
        'pause video',
      );
      ref.read(videoStateNotifierProvider.notifier).setPaused();
    } else {
      throw VideoControllerException('Cannot pause: video not initialized');
    }
  }

  @override
  Future<void> stop() async {
    if (_controller?.value.isInitialized == true) {
      await withOperationTimeout(
        Future.wait([
          _controller!.pause(),
          _controller!.seekTo(Duration.zero),
        ]),
        'stop video',
      );
      ref.read(videoStateNotifierProvider.notifier).setStopped();
    } else {
      throw VideoControllerException('Cannot stop: video not initialized');
    }
  }

  @override
  Future<void> seekTo(Duration position) async {
    if (_controller?.value.isInitialized == true) {
      await withOperationTimeout(
        _controller!.seekTo(position),
        'seek to position',
      );
      ref.read(videoStateNotifierProvider.notifier).updatePosition(position);
    } else {
      throw VideoControllerException('Cannot seek: video not initialized');
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (_controller?.value.isInitialized == true) {
      await withOperationTimeout(
        _controller!.setPlaybackSpeed(speed),
        'set playback speed',
      );
      ref.read(videoStateNotifierProvider.notifier).setSpeed(speed);
    } else {
      throw VideoControllerException('Cannot set speed: video not initialized');
    }
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _positionSubscription?.cancel();
    _controller?.dispose();
    _controller = null;

    // Clean up temporary file
    if (_tempFilePath != null) {
      try {
        final tempFile = File(_tempFilePath!);
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to delete temp video file: $e');
        }
      }
      _tempFilePath = null;
    }
  }
}
