import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_service.dart';
import 'core/storage/isar_service.dart';
import 'data/repositories/character_repository.dart';
import 'domain/use_cases/fetch_characters.dart';
import 'presentation/blocs/character_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isarService = IsarService();
  await isarService.init();

  final apiService = ApiService();
  final repository = CharacterRepository(apiService);
  final fetchCharactersUseCase = FetchCharacters(repository, isarService);

  runApp(MyApp(
      fetchCharactersUseCase: fetchCharactersUseCase,
      isarService: isarService));
}

class MyApp extends StatelessWidget {
  final FetchCharacters fetchCharactersUseCase;
  final IsarService isarService;

  const MyApp(
      {super.key,
      required this.fetchCharactersUseCase,
      required this.isarService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterCubit(fetchCharactersUseCase, isarService),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
