import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/use_cases/fetch_characters.dart';
import '../../core/storage/isar_service.dart';
import '../../data/models/character_model.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final FetchCharacters fetchCharactersUseCase;
  final IsarService isarService;

  List<Character> characters = [];
  List<Character> favoriteCharacters = [];
  String currentSearch = "";
  int currentPage = 1;
  bool isFetching = false;
  bool hasMore = true;

  CharacterCubit(this.fetchCharactersUseCase, this.isarService)
      : super(CharacterInitial()) {
    loadFavorites();
  }

  /// Cargar personajes desde la API con paginación
  Future<void> fetchCharacters({bool reset = false}) async {
    if (isFetching || !hasMore) return;

    if (reset) {
      currentPage = 1;
      characters.clear();
      hasMore = true;
    }

    try {
      isFetching = true;
      emit(CharacterLoading());

      final newCharacters = await fetchCharactersUseCase(currentPage);

      if (newCharacters.isEmpty) {
        hasMore = false;
      } else {
        characters.addAll(newCharacters);
        currentPage++;
      }

      emit(CharacterLoaded(characters));
    } catch (e) {
      emit(CharacterError(e.toString())); // ✅ Captura y envía el error a la UI
    } finally {
      isFetching = false;
    }
  }

  /// 🔍 Buscar personajes en la API con paginación
  Future<void> searchCharacters(String name, {bool reset = false}) async {
    if (isFetching || !hasMore) return;

    if (reset || name != currentSearch) {
      currentPage = 1;
      characters.clear();
      hasMore = true;
      currentSearch = name;
    }

    try {
      isFetching = true;
      emit(CharacterLoading());

      final newCharacters =
          await fetchCharactersUseCase(currentPage, search: name);

      if (newCharacters.isEmpty) {
        hasMore = false;
      } else {
        characters.addAll(newCharacters);
        currentPage++;
      }

      emit(CharacterLoaded(characters));
    } catch (e) {
      emit(CharacterError("No se encontraron resultados"));
    } finally {
      isFetching = false;
    }
  }

  /// Guardar personaje en favoritos
  Future<void> saveFavorite(Character character) async {
    await isarService.saveFavorite(character);
    loadFavorites();
    emit(CharacterLoaded(characters));
  }

  /// Cargar solo los personajes favoritos desde Isar
  Future<void> loadFavorites() async {
    favoriteCharacters = await isarService.getFavorites();
    emit(CharacterFavoritesLoaded(favoriteCharacters));
  }

  /// Eliminar personaje de favoritos
  Future<void> removeFavorite(int id) async {
    await isarService.removeFavorite(id);
    loadFavorites();
  }
}
