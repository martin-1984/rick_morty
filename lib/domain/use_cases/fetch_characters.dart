import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';
import '../../core/storage/isar_service.dart';

class FetchCharacters {
  final CharacterRepository repository;
  final IsarService isarService;

  FetchCharacters(this.repository, this.isarService);

  Future<List<Character>> call(int page,
      {String search = "", bool forceRefresh = false}) async {
    if (!forceRefresh && search.isEmpty) {
      final cachedCharacters = await isarService.getAllCharacters();
      if (cachedCharacters.isNotEmpty && page == 1) return cachedCharacters;
    }

    final characters = search.isEmpty
        ? await repository.getCharacters(page)
        : await repository.searchCharacters(search, page);

    if (search.isEmpty) {
      for (var character in characters) {
        await isarService.saveCharacter(character);
      }
    }

    return characters;
  }
}
