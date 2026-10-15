import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/hangman_round.dart';
import 'package:hangman_game/domain/models/round_status.dart';
import 'package:hangman_game/presentation/app_theme.dart';

/// Resultado da rodada: vitória ou derrota, resposta, erros e dica (RF10/RF11).
class RoundResultPanel extends StatelessWidget {
  const RoundResultPanel({
    super.key,
    required this.round,
    required this.onNewRound,
    required this.onChangeSelection,
  });

  final HangmanRound round;
  final VoidCallback onNewRound;
  final VoidCallback onChangeSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final won = round.status == RoundStatus.won;
    final color = won ? successColorOf(context) : theme.colorScheme.error;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              won ? 'Você venceu!' : 'Você perdeu!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _ResultLine(label: 'Resposta', value: round.answer.text),
            _ResultLine(
              label: 'Erros',
              value: '${round.errors} de ${round.maxErrors}',
            ),
            _ResultLine(
              label: 'Dica',
              value: round.hintUsed ? 'utilizada' : 'não utilizada',
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: onNewRound,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nova rodada'),
                ),
                OutlinedButton.icon(
                  onPressed: onChangeSelection,
                  icon: const Icon(Icons.tune),
                  label: const Text('Alterar categoria e nível'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
