import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/guess_outcome.dart';
import 'package:hangman_game/presentation/app_theme.dart';

/// Mensagem exibida após cada tentativa.
class GuessFeedback extends StatelessWidget {
  const GuessFeedback({super.key, required this.outcome, required this.letter});

  final GuessOutcome? outcome;
  final String? letter;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (message, color, icon) = switch (outcome) {
      GuessOutcome.hit => (
          'Boa! A letra $letter está na resposta.',
          successColorOf(context),
          Icons.check_circle_outline,
        ),
      GuessOutcome.miss => (
          'A letra $letter não está na resposta.',
          scheme.error,
          Icons.cancel_outlined,
        ),
      GuessOutcome.repeated => (
          'A letra $letter já foi utilizada.',
          scheme.onSurfaceVariant,
          Icons.info_outline,
        ),
      _ => (
          'Escolha uma letra.',
          scheme.onSurfaceVariant,
          Icons.touch_app_outlined,
        ),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Row(
        key: ValueKey(message),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
