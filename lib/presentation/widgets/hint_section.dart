import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/hangman_round.dart';

/// Botão para pedir a dica e, depois de usada, o cartão que a exibe (RF09).
class HintSection extends StatelessWidget {
  const HintSection({
    super.key,
    required this.round,
    required this.onRequestHint,
  });

  final HangmanRound round;
  final VoidCallback onRequestHint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (round.hintUsed) {
      return Card(
        color: scheme.secondaryContainer,
        child: ListTile(
          leading: Icon(Icons.lightbulb, color: scheme.onSecondaryContainer),
          title: const Text('Dica'),
          subtitle: Text(round.entry.hints.join('\n')),
        ),
      );
    }
    if (round.isFinished) return const SizedBox.shrink();
    return Center(
      child: OutlinedButton.icon(
        onPressed: onRequestHint,
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Ver dica'),
      ),
    );
  }
}
