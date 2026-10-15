import 'package:flutter/material.dart';
import 'package:hangman_game/application/game_controller.dart';
import 'package:hangman_game/presentation/screens/about_screen.dart';
import 'package:hangman_game/presentation/screens/statistics_screen.dart';

/// Botão da AppBar que abre as estatísticas da sessão.
class StatisticsAction extends StatelessWidget {
  const StatisticsAction({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Estatísticas',
      icon: const Icon(Icons.bar_chart),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => StatisticsScreen(controller: controller),
        ),
      ),
    );
  }
}

/// Botão da AppBar que abre a identificação da equipe.
class AboutAction extends StatelessWidget {
  const AboutAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Sobre a equipe',
      icon: const Icon(Icons.groups_outlined),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
      ),
    );
  }
}
