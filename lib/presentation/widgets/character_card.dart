import 'package:flutter/material.dart';
import '../screens/detail_screen.dart';
import '../../data/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(character: character),
          ),
        );
      },
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(character.image,
                width: 60, height: 60, fit: BoxFit.cover),
          ),
          title: Text(
            character.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            "Estado: ${character.status}",
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: Icon(
            character.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: character.isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
