import 'package:dio/dio.dart';
import '../models/character_model.dart';
import '../../core/network/api_service.dart';

class CharacterRepository {
  final ApiService apiService;

  CharacterRepository(this.apiService);

  Future<List<Character>> getCharacters(int page) async {
    Response response = await apiService.getCharacters(page);
    return response.data['results']
        .map<Character>((json) => Character.fromJson(json))
        .toList();
  }

  Future<List<Character>> searchCharacters(String name, int page) async {
    Response response = await apiService.searchCharacters(name, page);
    return response.data['results']
        .map<Character>((json) => Character.fromJson(json))
        .toList();
  }
}
