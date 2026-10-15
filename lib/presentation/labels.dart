import 'package:flutter/material.dart';
import 'package:hangman_game/domain/models/answer_category.dart';
import 'package:hangman_game/domain/models/difficulty.dart';

/// Textos em português e ícones exibidos para cada categoria.
extension AnswerCategoryPresentation on AnswerCategory {
  String get label => switch (this) {
        AnswerCategory.animals => 'Animais',
        AnswerCategory.humanBody => 'Corpo humano',
        AnswerCategory.sports => 'Esportes',
        AnswerCategory.technology => 'Tecnologia',
      };

  IconData get icon => switch (this) {
        AnswerCategory.animals => Icons.pets,
        AnswerCategory.humanBody => Icons.accessibility_new,
        AnswerCategory.sports => Icons.sports_soccer,
        AnswerCategory.technology => Icons.computer,
      };
}

/// Textos em português exibidos para cada nível de dificuldade.
extension DifficultyPresentation on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Fácil',
        Difficulty.medium => 'Médio',
        Difficulty.hard => 'Difícil',
      };
}
