import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://rickandmortyapi.com/api/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  ApiService() {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  /// 🔍 **Manejo centralizado de errores**
  Future<Response> _handleRequest(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Tiempo de espera agotado. Verifica tu conexión.");
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("No hay conexión a Internet.");
      } else if (e.response != null) {
        throw Exception(
            "Error ${e.response?.statusCode}: ${e.response?.statusMessage}");
      } else {
        throw Exception("Error inesperado: ${e.message}");
      }
    } catch (e) {
      throw Exception("Error desconocido: $e");
    }
  }

  /// 📥 Obtener personajes
  Future<Response> getCharacters(int page) async {
    return await _handleRequest(
        () => _dio.get('character', queryParameters: {'page': page}));
  }

  /// 🔎 Buscar personajes por nombre
  Future<Response> searchCharacters(String name, int page) async {
    return await _handleRequest(() =>
        _dio.get('character', queryParameters: {'name': name, 'page': page}));
  }
}
