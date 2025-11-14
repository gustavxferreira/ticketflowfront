import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketflowfront/app.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'http://localhost:5233/api',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'jwt');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            await storage.delete(key: 'jwt');

            // Navegação global
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Sempre checar se o Navigator está pronto
              if (navigatorKey.currentState?.mounted ?? false) {
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              } else {
                print("⚠️ Navigator ainda não está pronto.");
              }
            });
          } else if (e.type == DioErrorType.connectionTimeout) {
            print("Erro de conexão com o servidor.");
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }
}
