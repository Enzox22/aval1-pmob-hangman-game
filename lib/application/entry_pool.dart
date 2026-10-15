import 'dart:math';

import 'package:hangman_game/domain/models/answer_category.dart';
import 'package:hangman_game/domain/models/difficulty.dart';
import 'package:hangman_game/domain/models/hangman_entry.dart';

/// Sorteia respostas sem repetição durante a sessão.
///
/// Uma resposta sorteada só volta a ficar disponível quando o usuário pede
/// explicitamente para liberar as respostas da combinação (ver
/// [resetUsage]); nunca há repetição silenciosa.
class EntryPool {
  EntryPool(List<HangmanEntry> entries, {Random? random})
      : _entries = List.unmodifiable(entries),
        _random = random ?? Random();

  final List<HangmanEntry> _entries;
  final Random _random;
  final Set<HangmanEntry> _usedEntries = <HangmanEntry>{};

  /// Somente as categorias presentes no conjunto de dados.
  List<AnswerCategory> get categories => [
        for (final category in AnswerCategory.values)
          if (_entries.any((entry) => entry.category == category)) category,
      ];

  /// Somente os níveis presentes no conjunto de dados.
  List<Difficulty> get difficulties => [
        for (final difficulty in Difficulty.values)
          if (_entries.any((entry) => entry.difficulty == difficulty))
            difficulty,
      ];

  int totalCount(AnswerCategory category, Difficulty difficulty) =>
      _matching(category, difficulty).length;

  int remainingCount(AnswerCategory category, Difficulty difficulty) =>
      _available(category, difficulty).length;

  /// Sorteia uma resposta inédita ou retorna `null` se todas já foram usadas.
  HangmanEntry? pick(AnswerCategory category, Difficulty difficulty) {
    final available = _available(category, difficulty);
    if (available.isEmpty) return null;
    final entry = available[_random.nextInt(available.length)];
    _usedEntries.add(entry);
    return entry;
  }

  void resetUsage(AnswerCategory category, Difficulty difficulty) =>
      _usedEntries.removeWhere((entry) => entry.matches(category, difficulty));

  Iterable<HangmanEntry> _matching(
    AnswerCategory category,
    Difficulty difficulty,
  ) =>
      _entries.where((entry) => entry.matches(category, difficulty));

  List<HangmanEntry> _available(
    AnswerCategory category,
    Difficulty difficulty,
  ) =>
      _matching(category, difficulty)
          .where((entry) => !_usedEntries.contains(entry))
          .toList();
}
