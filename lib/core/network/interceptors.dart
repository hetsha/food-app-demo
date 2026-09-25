import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/local_storage.dart';
import 'api_client.dart';

class AuthInterceptor extends Interceptor {
  Future<bool>? _refreshInFlight;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = LocalStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/')) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newToken = LocalStorage.getAccessToken();
        final options = err.requestOptions;
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
        }
        try {
          final retryResponse = await ApiClient.instance.fetch(options);
          return handler.resolve(retryResponse);
        } catch (retryErr) {
          if (retryErr is DioException) {
            return handler.next(retryErr);
          }
        }
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshToken() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;
    final future = _performRefresh();
    _refreshInFlight = future;
    future.whenComplete(() {
      if (identical(_refreshInFlight, future)) {
        _refreshInFlight = null;
      }
    });
    return future;
  }

  Future<bool> _performRefresh() async {
    final refreshToken = LocalStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ));

      final response = await dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        final accessToken = data['accessToken'] ?? data['access_token'];
        final newRefreshToken = data['refreshToken'] ?? data['refresh_token'];
        if (accessToken != null) {
          await LocalStorage.setAccessToken(accessToken.toString());
        }
        if (newRefreshToken != null) {
          await LocalStorage.setRefreshToken(newRefreshToken.toString());
        }
        return true;
      }
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) {
        await LocalStorage.clearAuth();
      }
    } catch (_) {}
    return false;
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(err.response?.statusCode, err.response?.data);
        break;
      default:
        message = 'Something went wrong. Please try again.';
    }
    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: message,
      type: err.type,
      response: err.response,
    ));
  }

  String _handleBadResponse(int? statusCode, dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic> && error['message'] != null) {
        return error['message'].toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error.';
      case 429:
        return 'Too many requests. Please wait.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Error: $statusCode';
    }
  }
}
