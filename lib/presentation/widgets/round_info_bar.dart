import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/hangman_round.dart';
import 'package:hangman_game/presentation/labels.dart';

/// Categoria, dificuldade e progresso dos erros da rodada.
class RoundInfoBar extends StatelessWidget {
  const RoundInfoBar({super.key, required this.round});

  final HangmanRound round;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = round.entry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: Icon(entry.category.icon, size: 18),
              label: Text(entry.category.label),
            ),
            Chip(
              avatar: const Icon(Icons.speed, size: 18),
              label: Text(entry.difficulty.label),
            ),
            Chip(
              avatar: Icon(
                Icons.close,
                size: 18,
                color: theme.colorScheme.error,
              ),
              label: Text('Erros: ${round.errors} de ${round.maxErrors}'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: round.errors / round.maxErrors,
            minHeight: 6,
            color: theme.colorScheme.error,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}
