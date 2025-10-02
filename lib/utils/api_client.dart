import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/domain/models/api/api_error.dart';
import 'package:clones_desktop/domain/models/api/api_response.dart';
import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  ApiClient(this.ref, {String? baseUrl})
      : baseUrl = baseUrl ?? '${Env.apiBackendUrl}/api/v1';
  final String baseUrl;
  final Ref ref;

  Future<Map<String, String>> _getHeaders(RequestOptions options) async {
    final headers = <String, String>{};
    if (options.headers != null) {
      headers.addAll(options.headers!);
    }
    if (options.requiresAuth) {
      final token =
          ref.watch(sessionNotifierProvider.select((s) => s.connectionToken));
      if (token != null && token.isNotEmpty) {
        headers['x-connect-token'] = token;
      }
    }
    return headers;
  }

  dio.Dio get dioConfig => dio.Dio(
        dio.BaseOptions(
          baseUrl: baseUrl,
          headers: {'Authorization': 'Bearer'},
        ),
      );

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? params,
    RequestOptions options = const RequestOptions(),
    T Function(dynamic)? fromJson,
  }) async {
    final headers = await _getHeaders(options);
    try {
      final response = await dioConfig.get(
        endpoint,
        queryParameters: params,
        options: dio.Options(headers: headers),
      );
      final ApiResponse apiResponse;
      if (response.data is List) {
        apiResponse = ApiResponse(success: true, data: response.data);
      } else {
        apiResponse = ApiResponse.fromJson(response.data);
      }
      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiError(
          status: response.statusCode ?? 400,
          statusText: response.statusMessage ?? 'Error',
          message: apiResponse.error?.message ?? 'GET: $endpoint',
          data: apiResponse,
        );
      }
      if (fromJson != null) {
        return fromJson(apiResponse.data);
      }
      return apiResponse.data as T;
    } on dio.DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: apiResponse.error?.message ?? 'An unknown error occurred',
          data: apiResponse,
        );
      } else if (e.response != null) {
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: e.response!.data.toString(),
        );
      } else {
        throw ApiError(
          status: 500,
          statusText: 'Network Error',
          message: e.message ?? 'A network error occurred.',
        );
      }
    }
  }

  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    RequestOptions options = const RequestOptions(),
    T Function(dynamic)? fromJson,
  }) async {
    final headers = await _getHeaders(options);

    try {
      final response = await dioConfig.post(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
      );

      final ApiResponse apiResponse;
      if (response.data is List) {
        apiResponse = ApiResponse(success: true, data: response.data);
      } else {
        apiResponse = ApiResponse.fromJson(response.data);
      }

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiError(
          status: response.statusCode ?? 400,
          statusText: response.statusMessage ?? 'Error',
          message: apiResponse.error?.message ?? 'POST: $endpoint',
          data: apiResponse,
        );
      }
      if (fromJson != null) {
        return fromJson(apiResponse.data);
      }
      return apiResponse.data as T;
    } on dio.DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: apiResponse.error?.message ?? 'An unknown error occurred',
          data: apiResponse,
        );
      } else if (e.response != null) {
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: e.response!.data.toString(),
        );
      } else {
        throw ApiError(
          status: 500,
          statusText: 'Network Error',
          message: e.message ?? 'A network error occurred.',
        );
      }
    }
  }

  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    RequestOptions options = const RequestOptions(),
    T Function(dynamic)? fromJson,
  }) async {
    final headers = await _getHeaders(options);
    try {
      final response = await dioConfig.put(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
      );
      final ApiResponse apiResponse;
      if (response.data is List) {
        apiResponse = ApiResponse(success: true, data: response.data);
      } else {
        apiResponse = ApiResponse.fromJson(response.data);
      }
      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiError(
          status: response.statusCode ?? 400,
          statusText: response.statusMessage ?? 'Error',
          message: apiResponse.error?.message ?? 'PUT: $endpoint',
          data: apiResponse,
        );
      }
      if (fromJson != null) {
        return fromJson(apiResponse.data);
      }
      return apiResponse.data as T;
    } on dio.DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: apiResponse.error?.message ?? 'An unknown error occurred',
          data: apiResponse,
        );
      } else if (e.response != null) {
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: e.response!.data.toString(),
        );
      } else {
        throw ApiError(
          status: 500,
          statusText: 'Network Error',
          message: e.message ?? 'A network error occurred.',
        );
      }
    }
  }

  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    RequestOptions options = const RequestOptions(),
    T Function(dynamic)? fromJson,
  }) async {
    final headers = await _getHeaders(options);
    try {
      final response = await dioConfig.patch(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
      );
      final ApiResponse apiResponse;
      if (response.data is List) {
        apiResponse = ApiResponse(success: true, data: response.data);
      } else {
        apiResponse = ApiResponse.fromJson(response.data);
      }
      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiError(
          status: response.statusCode ?? 400,
          statusText: response.statusMessage ?? 'Error',
          message: apiResponse.error?.message ?? 'PATCH: $endpoint',
          data: apiResponse,
        );
      }
      if (fromJson != null) {
        return fromJson(apiResponse.data);
      }
      return apiResponse.data as T;
    } on dio.DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: apiResponse.error?.message ?? 'An unknown error occurred',
          data: apiResponse,
        );
      } else if (e.response != null) {
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: e.response!.data.toString(),
        );
      } else {
        throw ApiError(
          status: 500,
          statusText: 'Network Error',
          message: e.message ?? 'A network error occurred.',
        );
      }
    }
  }

  Future<T> delete<T>(
    String endpoint, {
    RequestOptions options = const RequestOptions(),
    T Function(dynamic)? fromJson,
  }) async {
    final headers = await _getHeaders(options);
    try {
      final response = await dioConfig.delete(
        endpoint,
        options: dio.Options(headers: headers),
      );
      final ApiResponse apiResponse;
      if (response.data is List) {
        apiResponse = ApiResponse(success: true, data: response.data);
      } else {
        apiResponse = ApiResponse.fromJson(response.data);
      }
      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiError(
          status: response.statusCode ?? 400,
          statusText: response.statusMessage ?? 'Error',
          message: apiResponse.error?.message ?? 'DELETE: $endpoint',
          data: apiResponse,
        );
      }
      if (fromJson != null) {
        return fromJson(apiResponse.data);
      }
      return apiResponse.data as T;
    } on dio.DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: apiResponse.error?.message ?? 'An unknown error occurred',
          data: apiResponse,
        );
      } else if (e.response != null) {
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: e.response!.data.toString(),
        );
      } else {
        throw ApiError(
          status: 500,
          statusText: 'Network Error',
          message: e.message ?? 'A network error occurred.',
        );
      }
    }
  }

  /// Get raw text response (bypasses JSON parsing)
  Future<String> getRawText(
    String endpoint, {
    Map<String, dynamic>? params,
    RequestOptions options = const RequestOptions(),
  }) async {
    final headers = await _getHeaders(options);
    try {
      final response = await dioConfig.get<String>(
        endpoint,
        queryParameters: params,
        options: dio.Options(
          headers: headers,
          responseType: dio.ResponseType.plain,
        ),
      );
      
      if (response.data == null) {
        throw ApiError(
          status: response.statusCode ?? 400,
          statusText: response.statusMessage ?? 'Error',
          message: 'No data received from server',
        );
      }
      
      return response.data!;
    } on dio.DioException catch (e) {
      if (e.response != null) {
        throw ApiError(
          status: e.response!.statusCode!,
          statusText: e.response!.statusMessage!,
          message: e.response!.data?.toString() ?? 'An error occurred',
        );
      } else {
        throw ApiError(
          status: 500,
          statusText: 'Network Error',
          message: e.message ?? 'A network error occurred.',
        );
      }
    }
  }
}

final apiClientProvider = Provider<ApiClient>(ApiClient.new);
