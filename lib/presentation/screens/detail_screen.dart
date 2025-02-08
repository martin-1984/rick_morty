import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/character_cubit.dart';
import '../../data/models/character_model.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CharacterCubit>();
    final isFavorite =
        cubit.favoriteCharacters.any((fav) => fav.id == character.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, cubit, isFavorite),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, CharacterCubit cubit, bool isFavorite) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.black,
      title: Text(character.name),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => _onFavoriteButtonPressed(context, cubit, isFavorite),
        ),
      ],
    );
  }

  void _onFavoriteButtonPressed(
      BuildContext context, CharacterCubit cubit, bool isFavorite) {
    if (isFavorite) {
      cubit.removeFavorite(character.id);
      _showSnackBar(context, "${character.name} eliminado de favoritos");
    } else {
      cubit.saveFavorite(character);
      _showSnackBar(context, "${character.name} agregado a favoritos");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCharacterImage(),
            const SizedBox(height: 20),
            _buildCharacterName(),
            const SizedBox(height: 20),
            _buildCharacterStatus(),
            const SizedBox(height: 20),
            const Expanded(child: SizedBox()),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(character.image,
          width: 200, height: 200, fit: BoxFit.cover),
    );
  }

  Widget _buildCharacterName() {
    return Text(
      character.name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCharacterStatus() {
    return Text(
      "Estado: ${character.status}",
      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Volver"),
      ),
    );
  }
}
