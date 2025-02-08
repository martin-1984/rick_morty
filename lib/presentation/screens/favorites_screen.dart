import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/character_cubit.dart';
import '../widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoritos")),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CharacterFavoritesLoaded) {
            if (state.characters.isEmpty) {
              return const Center(child: Text("No hay personajes favoritos"));
            }
            return ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                return CharacterCard(character: state.characters[index]);
              },
            );
          }
          return const Center(child: Text("Error al cargar favoritos"));
        },
      ),
    );
  }
}
