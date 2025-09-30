import 'dart:convert';
import 'dart:typed_data';

import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/recording/recording_meta.dart';
import 'package:clones_desktop/utils/window_alignment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TauriApiClient {
  TauriApiClient({http.Client? client}) : _client = client ?? http.Client();
  final String _baseUrl = 'http://127.0.0.1:19847';
  final http.Client _client;

  Future<List<RecordingMeta>> listRecordings() async {
    final response = await _client.get(Uri.parse('$_baseUrl/recordings'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => RecordingMeta.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recordings: ${response.body}');
    }
  }

  Future<void> writeRecordingFile({
    required String recordingId,
    required String filename,
    required String content,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/$recordingId/files'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'filename': filename,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to write recording file: ${response.body}');
    }
  }

  Future<String> getRecordingVideoUrl(String recordingId) async {
    // Client-side validation to prevent malicious input
    if (recordingId.isEmpty) {
      throw ArgumentError('Recording ID cannot be empty');
    }

    if (recordingId.length > 100) {
      throw ArgumentError('Recording ID too long');
    }

    // Prevent path traversal attacks
    if (recordingId.contains('..') ||
        recordingId.contains('/') ||
        recordingId.contains(r'\') ||
        recordingId.contains('\x00')) {
      throw ArgumentError('Invalid characters in recording ID');
    }

    // Only allow safe characters
    final safePattern = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!safePattern.hasMatch(recordingId)) {
      throw ArgumentError('Recording ID contains invalid characters');
    }

    final response = await _client.get(
      Uri.parse('$_baseUrl/recordings/$recordingId/video_url'),
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid response format: expected JSON object',
          );
        }

        final url = jsonResponse['url'];
        if (url == null) {
          throw const FormatException('Missing URL in response');
        }

        if (url is! String) {
          throw const FormatException('Invalid URL format: expected string');
        }

        // Basic URL validation
        if (url.isEmpty || !url.startsWith('http')) {
          throw const FormatException('Invalid URL format');
        }

        return url;
      } on FormatException catch (e) {
        throw FormatException('Failed to parse response: ${e.message}');
      } catch (e) {
        throw Exception('Unexpected error parsing response: $e');
      }
    } else {
      throw Exception(
        'Failed to get recording video url (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<String> getRecordingFile({
    required String recordingId,
    required String filename,
    bool asPath = false,
    bool asBase64 = false,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl/recordings/$recordingId/files?filename=$filename&asPath=$asPath&asBase64=$asBase64',
      ),
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Failed to get recording file: ${response.body}');
    }
  }

  Future<void> startRecording({Demonstration? demonstration}) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/start'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'demonstration': demonstration?.toJson(),
        'fps': 30,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start recording: ${response.body}');
    }
  }

  // TODO(reddwarf03): If fail, cancel record storage
  Future<String> stopRecording(String status) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/stop'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to stop recording: ${response.body}');
    }
  }

  Future<String> deleteRecording(String recordingId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/recordings/$recordingId'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete recording: ${response.body}');
    }
  }

  // TODO(reddwarf03): Not used ?
  Future<List<AppInfo>> listApps() async {
    final response = await _client.get(Uri.parse('$_baseUrl/apps'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => AppInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load apps: ${response.body}');
    }
  }

  Future<String> takeScreenshot() async {
    final response = await _client.get(Uri.parse('$_baseUrl/screenshot'));

    if (response.statusCode == 200) {
      // La réponse est directement la chaîne base64
      return response.body;
    } else {
      throw Exception('Failed to take screenshot: ${response.body}');
    }
  }

  Future<void> setUploadDataAllowed(bool allowed) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/settings/upload-allowed'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'allowed': allowed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set upload data allowed: ${response.body}');
    }
  }

  Future<bool> getUploadDataAllowed() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/settings/upload-allowed'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to check upload confirmation allowance: ${response.body}',
      );
    }
  }

  Future<bool> hasAxPerms() async {
    final response = await _client.get(Uri.parse('$_baseUrl/permissions/ax'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['has_permission'] ?? false;
    } else {
      throw Exception(
        'Failed to get accessibility permissions: ${response.body}',
      );
    }
  }

  // --- Permissions & Settings ---

  Future<bool> hasRecordPerms() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/permissions/record'));
    if (response.statusCode == 200) {
      return (json.decode(response.body)['has_permission']) ?? false;
    }
    throw Exception('Failed to get record permissions: ${response.body}');
  }

  Future<void> requestRecordPerms() async {
    final response =
        await _client.post(Uri.parse('$_baseUrl/permissions/record/request'));
    if (response.statusCode != 200) {
      throw Exception('Failed to request record permissions: ${response.body}');
    }
  }

  Future<void> requestAxPerms() async {
    final response =
        await _client.post(Uri.parse('$_baseUrl/permissions/ax/request'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to request accessibility permissions: ${response.body}',
      );
    }
  }

  Future<bool> getOnboardingComplete() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/onboarding/complete'));
    if (response.statusCode == 200) {
      return (json.decode(response.body)['has_permission']) ?? false;
    }
    throw Exception('Failed to get onboarding status: ${response.body}');
  }

  Future<void> setOnboardingComplete(bool complete) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/onboarding/complete'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'complete': complete}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to set onboarding status: ${response.body}');
    }
  }

  // --- Tools ---

  Future<void> initTools() async {
    final response = await _client.post(Uri.parse('$_baseUrl/tools/init'));
    if (response.statusCode != 200) {
      throw Exception('Failed to initialize tools: ${response.body}');
    }
  }

  Future<Map<String, bool>> checkTools() async {
    final response = await _client.get(Uri.parse('$_baseUrl/tools/check'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.map((key, value) => MapEntry(key, value as bool));
    } else {
      throw Exception('Failed to check tools: ${response.body}');
    }
  }

  // --- Recording Actions ---

  Future<void> processRecording(String recordingId) async {
    final response = await _client
        .post(Uri.parse('$_baseUrl/recordings/$recordingId/process'));
    if (response.statusCode != 200) {
      throw Exception('Failed to process recording: ${response.body}');
    }
  }

  Future<void> openRecordingsFolder() async {
    final response =
        await _client.post(Uri.parse('$_baseUrl/recordings//open'));
    if (response.statusCode != 200) {
      throw Exception('Failed to open recording folder: ${response.body}');
    }
  }

  Future<void> openRecordingFolder(String recordingId) async {
    final response =
        await _client.post(Uri.parse('$_baseUrl/recordings/$recordingId/open'));
    if (response.statusCode != 200) {
      throw Exception('Failed to open recording folder: ${response.body}');
    }
  }


  Future<Uint8List> getRecordingZip(String recordingId) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/recordings/$recordingId/zip'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to get recording zip: ${response.body}');
    }
  }

  Future<Uint8List> getFilteredRecordingZip(String recordingId, List<Map<String, double>> deletedRanges) async {
    debugPrint('🔍 [getFilteredRecordingZip] Called with recordingId: $recordingId, deletedRanges: $deletedRanges');
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/$recordingId/filtered-zip'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'deleted_ranges': deletedRanges}),
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to get filtered recording zip: ${response.body}');
    }
  }

  // --- Deep Link ---

  Future<String?> getDeepLink() async {
    final response = await _client.get(Uri.parse('$_baseUrl/deeplink'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get deep link: ${response.body}');
    }
  }

  Future<void> openExternalUrl(String url) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/open-url'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'url': url}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to open external URL: ${response.body}');
    }
  }

  Future<String> getPlatform() async {
    final response = await _client.get(Uri.parse('$_baseUrl/platform'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get platform: ${response.body}');
    }
  }

  Future<String> getAppVersion() async {
    final response = await _client.get(Uri.parse('$_baseUrl/app/version'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['version'] as String;
    } else {
      throw Exception('Failed to get app version: ${response.body}');
    }
  }

  Future<Uint8List> fetchImageViaProxy(String imageUrl) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/proxy-image?url=$imageUrl'),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
        'Failed to proxy image ${'$_baseUrl/proxy-image?url=$imageUrl'}: ${response.body}',
      );
    }
  }

  Future<void> resizeWindow(
    double width,
    double height,
  ) async {
    await _client.post(
      Uri.parse('$_baseUrl/window/resize'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'width': width,
        'height': height,
      }),
    );
  }

  Future<void> setWindowPosition(WindowAlignment alignment) async {
    await _client.post(
      Uri.parse('$_baseUrl/window/position'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'alignment': alignment.name}),
    );
  }

  Future<({double width, double height})> getWindowSize() async {
    final response = await _client.get(Uri.parse('$_baseUrl/window/size'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (
        width: (data['width'] as num).toDouble(),
        height: (data['height'] as num).toDouble(),
      );
    } else {
      throw Exception('Failed to get window size: ${response.body}');
    }
  }

  Future<void> setWindowResizable(bool resizable) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/window/resizable'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'resizable': resizable}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set window resizable: ${response.body}');
    }
  }

  Future<List<({double width, double height})>> getDisplaysSize() async {
    final response = await _client.get(Uri.parse('$_baseUrl/displays/size'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map(
            (json) => (
              width: (json['width'] as num).toDouble(),
              height: (json['height'] as num).toDouble(),
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to get displays size: ${response.body}');
    }
  }

  // --- Transaction Methods ---

  /// Generate a new session token for secure transaction workflow
  Future<String> generateSessionToken() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/transaction/session'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to generate session token: ${response.body}');
    }
  }

  // --- Secure Tauri Updater ---

  /// Check for updates using Tauri's secure updater
  Future<Map<String, dynamic>?> checkForUpdate() async {
    final response = await _client.get(Uri.parse('$_baseUrl/updater/check'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['update_available'] == true ? data : null;
    } else {
      throw Exception('Failed to check for update: ${response.body}');
    }
  }

  /// Download and install update using Tauri's secure updater
  Future<void> installUpdate() async {
    final response = await _client.post(Uri.parse('$_baseUrl/updater/install'));
    if (response.statusCode != 200) {
      throw Exception('Failed to install update: ${response.body}');
    }
  }
}
