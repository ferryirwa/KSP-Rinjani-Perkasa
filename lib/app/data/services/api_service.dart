import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  static const String _skipAuthKey = 'skipAuth';

  static final ApiService _instance =
      ApiService._internal();

  factory ApiService() => _instance;

  static String? _activeBaseUrl;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 45),
        sendTimeout: const Duration(seconds: 20),

        responseType: ResponseType.json,
        followRedirects: true,
        receiveDataWhenStatusError: true,

        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) async {
          final skipAuth =
              options.extra[_skipAuthKey] == true;

          if (!skipAuth) {
            final token =
                await StorageService.getToken();

            if (token != null &&
                token.trim().isNotEmpty) {
              options.headers['Authorization'] =
                  'Bearer ${token.trim()}';
            }
          }

          if (kDebugMode) {
            debugPrint(
              '[API REQUEST] '
              '${options.method} ${options.uri}',
            );
          }

          handler.next(options);
        },

        onResponse: (
          Response<dynamic> response,
          ResponseInterceptorHandler handler,
        ) {
          if (kDebugMode) {
            debugPrint(
              '[API RESPONSE] '
              '${response.statusCode} '
              '${response.requestOptions.uri}',
            );

            debugPrint(
              '[API DATA] ${response.data}',
            );
          }

          handler.next(response);
        },

        onError: (
          DioException error,
          ErrorInterceptorHandler handler,
        ) {
          if (kDebugMode) {
            debugPrint(
              '[API ERROR TYPE] ${error.type}',
            );

            debugPrint(
              '[API ERROR URL] '
              '${error.requestOptions.uri}',
            );

            debugPrint(
              '[API ERROR MESSAGE] ${error.message}',
            );

            debugPrint(
              '[API ERROR CAUSE] ${error.error}',
            );

            debugPrint(
              '[API ERROR STATUS] '
              '${error.response?.statusCode}',
            );

            debugPrint(
              '[API ERROR DATA] '
              '${error.response?.data}',
            );
          }

          handler.next(error);
        },
      ),
    );
  }

  /// Memastikan base URL selalu berakhir dengan "/".
  String _normalizeBaseUrl(String baseUrl) {
    final normalized = baseUrl.trim();

    if (normalized.endsWith('/')) {
      return normalized;
    }

    return '$normalized/';
  }

  /// Menghapus "/" pada awal endpoint.
  ///
  /// Contoh:
  /// /admin/dashboard menjadi admin/dashboard
  String _normalizePath(String path) {
    var normalized = path.trim();

    while (normalized.startsWith('/')) {
      normalized = normalized.substring(1);
    }

    return normalized;
  }

  /// Membentuk URL lengkap secara aman.
  String _buildUrl(
    String baseUrl,
    String path,
  ) {
    final parsedPath = Uri.tryParse(path);

    if (parsedPath != null &&
        parsedPath.hasScheme) {
      return path;
    }

    return '${_normalizeBaseUrl(baseUrl)}'
        '${_normalizePath(path)}';
  }

  List<String> get _baseUrlCandidates {
    final normalizedUrls = ApiConstants.baseUrls
        .map(_normalizeBaseUrl)
        .toSet()
        .toList();

    final activeBaseUrl = _activeBaseUrl == null
        ? null
        : _normalizeBaseUrl(
            _activeBaseUrl!,
          );

    if (activeBaseUrl == null ||
        !normalizedUrls.contains(activeBaseUrl)) {
      return normalizedUrls;
    }

    return [
      activeBaseUrl,
      ...normalizedUrls.where(
        (url) => url != activeBaseUrl,
      ),
    ];
  }

  bool _canTryNextBaseUrl(
    DioException error,
  ) {
    return error.type ==
            DioExceptionType.connectionTimeout ||
        error.type ==
            DioExceptionType.connectionError;
  }

  Options _options({
    bool requiresAuth = true,
    String? contentType,
  }) {
    return Options(
      contentType: contentType,
      extra: {
        _skipAuthKey: !requiresAuth,
      },
    );
  }

  Future<Response<dynamic>> _requestWithFallback(
    String path,
    Future<Response<dynamic>> Function(
      String fullUrl,
    ) request,
  ) async {
    final candidates = _baseUrlCandidates;

    if (candidates.isEmpty) {
      throw StateError(
        'Base URL API belum dikonfigurasi.',
      );
    }

    DioException? lastError;

    for (var index = 0;
        index < candidates.length;
        index++) {
      final baseUrl = candidates[index];
      final fullUrl = _buildUrl(
        baseUrl,
        path,
      );

      try {
        final response = await request(
          fullUrl,
        );

        _activeBaseUrl = baseUrl;

        return response;
      } on DioException catch (error) {
        lastError = error;

        final isLastCandidate =
            index == candidates.length - 1;

        if (!_canTryNextBaseUrl(error) ||
            isLastCandidate) {
          rethrow;
        }

        if (kDebugMode) {
          debugPrint(
            '[API FALLBACK] Gagal mengakses '
            '$baseUrl, mencoba URL berikutnya.',
          );
        }
      }
    }

    if (lastError != null) {
      throw lastError;
    }

    throw StateError(
      'Request API gagal diproses.',
    );
  }

  Future<Response<dynamic>> get(
    String path, {
    bool requiresAuth = true,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.get(
        fullUrl,
        queryParameters: queryParameters,
        options: _options(
          requiresAuth: requiresAuth,
        ),
      ),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    bool requiresAuth = true,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.post(
        fullUrl,
        data: data,
        queryParameters: queryParameters,
        options: _options(
          requiresAuth: requiresAuth,
        ),
      ),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    bool requiresAuth = true,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.put(
        fullUrl,
        data: data,
        options: _options(
          requiresAuth: requiresAuth,
        ),
      ),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    bool requiresAuth = true,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.patch(
        fullUrl,
        data: data,
        options: _options(
          requiresAuth: requiresAuth,
        ),
      ),
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    bool requiresAuth = true,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.delete(
        fullUrl,
        data: data,
        options: _options(
          requiresAuth: requiresAuth,
        ),
      ),
    );
  }

  Future<Response<dynamic>> postMultipart(
    String path, {
    required FormData data,
    bool requiresAuth = true,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.post(
        fullUrl,
        data: data,
        options: _options(
          requiresAuth: requiresAuth,
          contentType: 'multipart/form-data',
        ),
      ),
    );
  }

  Future<Response<dynamic>> download(
    String path,
    String savePath, {
    bool requiresAuth = true,
    ProgressCallback? onReceiveProgress,
  }) {
    return _requestWithFallback(
      path,
      (fullUrl) => _dio.download(
        fullUrl,
        savePath,
        options: _options(
          requiresAuth: requiresAuth,
        ),
        onReceiveProgress:
            onReceiveProgress,
      ),
    );
  }
}
