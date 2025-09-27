import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:clones_desktop/ui/components/video_player/video_controller.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:web/web.dart' as web;

class WebVideoControllerImpl extends WebVideoController {
  WebVideoControllerImpl(super.source, super.ref, this._videoId);
  final String _videoId;
  web.HTMLVideoElement? _video;
  String? _objectUrl;
  String? _viewType;
  Timer? _fallbackTimer;
  StreamSubscription? _positionUpdateSubscription;
  bool _isDisposed = false;

  // Event listeners
  StreamSubscription? _onPlaySubscription;
  StreamSubscription? _onPauseSubscription;
  StreamSubscription? _onTimeUpdateSubscription;
  StreamSubscription? _onLoadedMetadataSubscription;
  StreamSubscription? _onWaitingSubscription;
  StreamSubscription? _onCanPlaySubscription;
  StreamSubscription? _onRateChangeSubscription;

  String? get viewType => _viewType;
  web.HTMLVideoElement? get videoElement => _video;

  @override
  Future<void> initialize() async {
    try {
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setStatus(VideoPlayerStatus.loading);

      // Fallback timer for initialization
      _fallbackTimer = Timer(const Duration(seconds: 35), () {
        if (_video?.readyState != 4) {
          // HAVE_ENOUGH_DATA
          throw VideoControllerException(
            'Web video initialization timeout - fallback triggered',
          );
        }
      });

      // Get video data based on source type
      late String srcUrl;

      switch (source) {
        case AssetVideoSource(path: final path):
          final data = await withInitializationTimeout(
            rootBundle.load(path),
            'load video asset',
          );
          final bytes = data.buffer.asUint8List();
          final blob = web.Blob(
            [bytes.buffer].jsify()! as JSArray<web.BlobPart>,
            web.BlobPropertyBag(type: 'video/mp4'),
          );
          srcUrl = web.URL.createObjectURL(blob);
          _objectUrl = srcUrl;

        case Base64VideoSource(dataUri: final dataUri):
          // Use data URI directly for base64 source
          srcUrl = dataUri;

        case FileVideoSource():
          throw VideoControllerException(
            'FileVideoSource is not supported on the web',
          );
      }

      // Create video element with quality optimizations
      _video = web.HTMLVideoElement()
        ..src = srcUrl
        ..controls = false
        ..preload = 'auto' // Preload more for better quality
        ..setAttribute('playsinline', 'true')
        ..setAttribute('webkit-playsinline', 'true')
        // Video scaling and rendering
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.backgroundColor = 'black'
        ..style.objectFit = 'cover'
        ..muted = true
        ..autoplay = false;

      // Setup event listeners with error handling
      _setupEventListeners();

      // Register platform view
      _viewType = 'video-element-${DateTime.now().microsecondsSinceEpoch}';
      ui_web.platformViewRegistry
          .registerViewFactory(_viewType!, (int _) => _video!);

      _fallbackTimer?.cancel();

      // Wait for metadata to be loaded
      await withInitializationTimeout(
        _waitForMetadata(),
        'wait for video metadata',
      );

      final duration =
          Duration(milliseconds: (_video!.duration * 1000).round());
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setReady(duration);
    } catch (e) {
      _fallbackTimer?.cancel();

      // Graceful degradation
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setError('Failed to initialize web video: $e');

      if (kDebugMode) {
        print(
          'Web video initialization failed, graceful degradation activated',
        );
      }
      rethrow;
    }
  }

  Future<void> _waitForMetadata() async {
    final completer = Completer<void>();

    void onLoadedMetadata() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    _video!.addEventListener('loadedmetadata', onLoadedMetadata.toJS);

    // If metadata is already loaded
    if (_video!.readyState >= 1) {
      completer.complete();
    }

    return completer.future;
  }

  void _setupEventListeners() {
    _onPlaySubscription = _video!.onPlay.listen((_) {
      ref.read(videoStateNotifierProvider(_videoId).notifier).setPlaying();
    });

    _onPauseSubscription = _video!.onPause.listen((_) {
      ref.read(videoStateNotifierProvider(_videoId).notifier).setPaused();
    });

    _onWaitingSubscription = _video!.onWaiting.listen((_) {
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setStatus(VideoPlayerStatus.loading);
    });

    _onCanPlaySubscription = _video!.onCanPlay.listen((_) {
      final currentStatus =
          ref.read(videoStateNotifierProvider(_videoId)).status;
      if (currentStatus == VideoPlayerStatus.loading) {
        ref
            .read(videoStateNotifierProvider(_videoId).notifier)
            .setStatus(VideoPlayerStatus.ready);
      }
    });

    _onRateChangeSubscription = _video!.onRateChange.listen((_) {
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setSpeed(_video!.playbackRate);
    });

    _onTimeUpdateSubscription = _video!.onTimeUpdate.listen((_) {
      final position =
          Duration(milliseconds: (_video!.currentTime * 1000).round());
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .updatePosition(position);
    });
  }

  @override
  Future<void> play() async {
    if (_video == null) {
      throw VideoControllerException('Cannot play: video not initialized');
    }

    await withOperationTimeout(
      _video!.play().toDart,
      'play web video',
    );
    ref.read(videoStateNotifierProvider(_videoId).notifier).setPlaying();
  }

  @override
  Future<void> pause() async {
    if (_video == null) {
      throw VideoControllerException('Cannot pause: video not initialized');
    }

    _video!.pause();
    ref.read(videoStateNotifierProvider(_videoId).notifier).setPaused();
  }

  @override
  Future<void> stop() async {
    if (_video == null) {
      throw VideoControllerException('Cannot stop: video not initialized');
    }

    _video!.pause();
    _video!.currentTime = 0;
    ref.read(videoStateNotifierProvider(_videoId).notifier).setStopped();
  }

  @override
  Future<void> seekTo(Duration position) async {
    if (_video == null) {
      throw VideoControllerException('Cannot seek: video not initialized');
    }

    _video!.currentTime = position.inMilliseconds / 1000.0;
    ref
        .read(videoStateNotifierProvider(_videoId).notifier)
        .updatePosition(position);
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (_video == null) {
      throw VideoControllerException('Cannot set speed: video not initialized');
    }

    _video!.playbackRate = speed;
    ref.read(videoStateNotifierProvider(_videoId).notifier).setSpeed(speed);
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    // Cancel all timers and subscriptions first
    _fallbackTimer?.cancel();
    _positionUpdateSubscription?.cancel();

    // Cancel all event listeners
    _onPlaySubscription?.cancel();
    _onPauseSubscription?.cancel();
    _onTimeUpdateSubscription?.cancel();
    _onLoadedMetadataSubscription?.cancel();
    _onWaitingSubscription?.cancel();
    _onCanPlaySubscription?.cancel();
    _onRateChangeSubscription?.cancel();

    // Clean up video element properly
    if (_video != null) {
      _video!.pause();
      _video!.removeAttribute('src');
      _video!.load(); // This clears the video buffer
    }

    // Unregister platform view to prevent memory leaks
    if (_viewType != null) {
      try {
        // Note: Flutter web doesn't provide unregisterViewFactory,
        // but setting video to null should clean up the reference
        _video = null;
      } catch (e) {
        // Ignore cleanup errors
      }
    }

    // Clean up blob URL
    if (_objectUrl != null) {
      web.URL.revokeObjectURL(_objectUrl!);
      _objectUrl = null;
    }

    _viewType = null;
  }
}
