import 'package:flutter/material.dart';
import 'package:hangman_game/presentation/team_members.dart';

/// Identificação dos integrantes da equipe (RF14).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Jogo da Forca', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                const Text(
                  'Programação para Dispositivos Móveis — UESPI\n'
                  'Tecnologia em Sistemas de Computação',
                ),
                const SizedBox(height: 24),
                Text('Equipe', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final member in teamMembers)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(member),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
