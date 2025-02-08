import 'package:isar/isar.dart';

part 'character_model.g.dart';

@Collection()
class Character {
  Id id;
  String name;
  String image;
  String status;
  @Index()
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    this.isFavorite = false,
  });

  Character.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        status = json['status'],
        isFavorite = false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'status': status,
      };
}
