import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/answer.dart';
import 'package:hangman_game/domain/models/hangman_round.dart';
import 'package:hangman_game/domain/models/round_status.dart';

/// Resposta parcialmente revelada. Cada palavra é um bloco separado, para
/// deixar claros os limites entre palavras; palavras longas são reduzidas
/// para caber na largura disponível, evitando overflow.
class AnswerBoard extends StatelessWidget {
  const AnswerBoard({super.key, required this.round});

  final HangmanRound round;

  @override
  Widget build(BuildContext context) {
    final revealMissing = round.status == RoundStatus.lost;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        for (final word in round.answer.words)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final character in word)
                  _AnswerCell(
                    character: character,
                    isRevealed: round.isRevealed(character),
                    revealMissing: revealMissing,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AnswerCell extends StatelessWidget {
  const _AnswerCell({
    required this.character,
    required this.isRevealed,
    required this.revealMissing,
  });

  final AnswerCharacter character;
  final bool isRevealed;
  final bool revealMissing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    // Hífens e outros caracteres estruturais aparecem sempre, sem traço.
    if (!character.isLetter) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(character.original, style: textStyle),
      );
    }

    final isMissed = !isRevealed && revealMissing;
    return Container(
      width: 30,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.onSurface, width: 3),
        ),
      ),
      child: Text(
        isRevealed || isMissed ? character.original : '',
        style: textStyle?.copyWith(
          color: isMissed ? theme.colorScheme.error : null,
        ),
      ),
    );
  }
}
