import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/character_model.dart';

class IsarService {
  late Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([CharacterSchema], directory: dir.path);
  }

  Future<void> saveCharacter(Character character) async {
    await _isar.writeTxn(() async {
      await _isar.characters.put(character);
    });
  }

  Future<List<Character>> getAllCharacters() async {
    return await _isar.characters.where().findAll();
  }

  Future<void> deleteCharacter(int id) async {
    await _isar.writeTxn(() async {
      await _isar.characters.delete(id);
    });
  }

  /// ❤️ **Guardar o Actualizar un Personaje como Favorito**
  Future<void> saveFavorite(Character character) async {
    await _isar.writeTxn(() async {
      character.isFavorite = true; // ✅ Marcar como favorito
      await _isar.characters.put(character);
    });
  }

  /// 🔄 **Obtener todos los personajes favoritos**
  Future<List<Character>> getFavorites() async {
    return await _isar.characters
        .filter()
        .isFavoriteEqualTo(true)
        .findAll(); // ✅ Solo los favoritos
  }

  /// ❌ **Eliminar un personaje de favoritos**
  Future<void> removeFavorite(int id) async {
    await _isar.writeTxn(() async {
      final character = await _isar.characters.get(id);
      if (character != null) {
        character.isFavorite = false; // ✅ Desmarcar como favorito
        await _isar.characters.put(character);
      }
    });
  }
}
