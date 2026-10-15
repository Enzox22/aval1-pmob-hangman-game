import 'package:flutter/material.dart';
import 'package:hangman_game/domain/repositories/entry_repository.dart';
import 'package:hangman_game/presentation/app_theme.dart';
import 'package:hangman_game/presentation/screens/entry_loader.dart';

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key, required this.repository});

  final EntryRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      home: EntryLoader(repository: repository),
    );
  }
}
