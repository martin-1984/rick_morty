import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/character_cubit.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollController();
  }

  void _initializeData() {
    Future.microtask(() {
      context.read<CharacterCubit>().fetchCharacters();
      context.read<CharacterCubit>().loadFavorites();
    });
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        _fetchCharactersBasedOnSearch();
      }
    });
  }

  void _fetchCharactersBasedOnSearch() {
    if (_searchController.text.isEmpty) {
      context.read<CharacterCubit>().fetchCharacters();
    } else {
      context.read<CharacterCubit>().searchCharacters(_searchController.text);
    }
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<CharacterCubit>().searchCharacters(query, reset: true);
    } else {
      context.read<CharacterCubit>().fetchCharacters(reset: true);
    }
  }

  Future<void> _refresh() async {
    context.read<CharacterCubit>().fetchCharacters(reset: true);
    context.read<CharacterCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchField(),
          _buildCharacterList(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.black,
      title: const Text("Rick & Morty"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refresh,
        ),
      ],
    );
  }

  Padding _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: "Buscar personaje...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            _search();
          }
        },
        onSubmitted: (_) => _search(),
      ),
    );
  }

  Expanded _buildCharacterList() {
    return Expanded(
      child: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterError) {
            return _buildErrorState(state);
          } else if (state is CharacterLoaded ||
              state is CharacterFavoritesLoaded) {
            return _buildCharacterListView(state);
          } else {
            return const Center(child: Text("Cargando..."));
          }
        },
      ),
    );
  }

  Center _buildErrorState(CharacterError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: ${state.message}"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _refresh,
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterListView(CharacterState state) {
    final characters = state is CharacterLoaded
        ? state.characters
        : context.read<CharacterCubit>().characters;

    if (characters.isEmpty) {
      return const Center(child: Text("No se encontraron personajes"));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: characters.length,
        itemBuilder: (context, index) {
          if (index == characters.length) {
            return context.read<CharacterCubit>().hasMore
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }
          final character = characters[index];
          return CharacterCard(character: character);
        },
      ),
    );
  }
}
