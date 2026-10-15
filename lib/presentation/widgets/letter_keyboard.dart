import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/letter_state.dart';
import 'package:hangman_game/presentation/app_theme.dart';

/// Teclado com as letras de A a Z — as únicas tentativas possíveis.
/// Letras acentuadas e Ç são cobertas pela normalização (ex.: A cobre Ã).
class LetterKeyboard extends StatelessWidget {
  const LetterKeyboard({
    super.key,
    required this.letterStateOf,
    required this.onLetterSelected,
  });

  static final List<String> letters = List.unmodifiable(
    List.generate(26, (index) => String.fromCharCode(0x41 + index)),
  );

  static const int _columns = 7;
  static const double _spacing = 6;

  final LetterState Function(String letter) letterStateOf;
  final ValueChanged<String> onLetterSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth =
            ((constraints.maxWidth - _spacing * (_columns - 1)) / _columns)
                .clamp(32.0, 56.0)
                .toDouble();
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final letter in letters)
              _LetterKey(
                letter: letter,
                state: letterStateOf(letter),
                width: keyWidth,
                onPressed: () => onLetterSelected(letter),
              ),
          ],
        );
      },
    );
  }
}

class _LetterKey extends StatelessWidget {
  const _LetterKey({
    required this.letter,
    required this.state,
    required this.width,
    required this.onPressed,
  });

  final String letter;
  final LetterState state;
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (state) {
      LetterState.unused => (scheme.primaryContainer, scheme.onPrimaryContainer),
      LetterState.hit => (successColorOf(context), onSuccessColorOf(context)),
      LetterState.miss => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
    };
    final stateDescription = switch (state) {
      LetterState.unused => 'disponível',
      LetterState.hit => 'acertada',
      LetterState.miss => 'errada',
    };
    return Semantics(
      label: 'Letra $letter, $stateDescription',
      excludeSemantics: true,
      button: true,
      child: SizedBox(
        width: width,
        height: 48,
        child: FilledButton(
          // Letras já usadas ficam desabilitadas: não geram nova tentativa.
          onPressed: state == LetterState.unused ? onPressed : null,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(32, 40),
            backgroundColor: background,
            foregroundColor: foreground,
            disabledBackgroundColor: background,
            disabledForegroundColor: foreground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: state == LetterState.miss
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
