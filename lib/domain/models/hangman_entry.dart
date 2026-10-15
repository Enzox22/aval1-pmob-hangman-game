import 'package:hangman_game/domain/models/answer.dart';
import 'package:hangman_game/domain/models/answer_category.dart';
import 'package:hangman_game/domain/models/difficulty.dart';

/// Uma entrada do conjunto de dados: resposta, categoria, nível e dicas.
class HangmanEntry {
  HangmanEntry({
    required this.answer,
    required this.category,
    required this.difficulty,
    required List<String> hints,
  }) : hints = List.unmodifiable(hints);

  final Answer answer;
  final AnswerCategory category;
  final Difficulty difficulty;
  final List<String> hints;

  bool matches(AnswerCategory category, Difficulty difficulty) =>
      this.category == category && this.difficulty == difficulty;
}
