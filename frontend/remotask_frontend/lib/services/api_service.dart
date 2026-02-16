import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String baseUrl = 'http://localhost:3000/api/v1'; // Change for production

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor to attach JWT token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired or invalid, logout user
          await _storage.delete(key: 'auth_token');
        }
        return handler.next(error);
      },
    ));
  }

  // Authentication
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/register', data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Worker APIs
  Future<List<dynamic>> getAvailableTasks() async {
    try {
      final response = await _dio.get('/tasks');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getTaskDetails(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> submitTask(String taskId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/submissions', data: {
        'taskId': taskId,
        ...data,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getMySubmissions() async {
    try {
      final response = await _dio.get('/submissions');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getWallet() async {
    try {
      final response = await _dio.get('/wallet');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> requestWithdrawal(double amount, String method) async {
    try {
      final response = await _dio.post('/wallet/withdraw', data: {
        'amount': amount,
        'payment_method': method,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Client APIs
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/tasks', data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getMyTasks() async {
    try {
      final response = await _dio.get('/tasks');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getTaskSubmissions(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId/submissions');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> approveSubmission(String submissionId) async {
    try {
      final response = await _dio.post('/submissions/$submissionId/approve');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> rejectSubmission(String submissionId, String reason) async {
    try {
      final response = await _dio.post('/submissions/$submissionId/reject', data: {
        'reason': reason,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Admin APIs
  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final response = await _dio.get('/admin/stats');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await _dio.get('/admin/users');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getAllPayoutRequests() async {
    try {
      final response = await _dio.get('/admin/payouts');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> approvePayout(String payoutId) async {
    try {
      final response = await _dio.put('/admin/payouts/$payoutId/approve');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // File upload
  Future<Map<String, dynamic>> uploadFile(String filePath, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await _dio.post('/upload', data: formData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'An error occurred';
      } else {
        return 'Network error. Please check your connection.';
      }
    }
    return 'An unexpected error occurred';
  }
}
