import 'package:hangman_game/domain/letter_normalizer.dart';

/// Um caractere da resposta, com a grafia original e a forma normalizada.
class AnswerCharacter {
  AnswerCharacter(this.original)
      : normalized = normalizeLetter(original),
        isLetter = isGuessableLetter(original);

  /// Caractere exatamente como aparece no JSON (ex.: `Ã`).
  final String original;

  /// Caractere usado nas comparações (ex.: `A`).
  final String normalized;

  /// `true` para letras; `false` para hífens, apóstrofos e outros
  /// caracteres estruturais, que são exibidos desde o início da rodada.
  final bool isLetter;
}

/// Resposta de uma rodada, formada por uma ou mais palavras.
class Answer {
  factory Answer(String text) {
    final trimmed = text.trim();
    final words = trimmed.isEmpty
        ? const <List<AnswerCharacter>>[]
        : trimmed.split(_whitespace).map(_parseWord).toList(growable: false);
    final letters = {
      for (final word in words)
        for (final character in word)
          if (character.isLetter) character.normalized,
    };
    if (letters.isEmpty) {
      throw FormatException('A resposta "$text" não contém letras.');
    }
    return Answer._(trimmed, words, Set.unmodifiable(letters));
  }

  const Answer._(this.text, this.words, this.letters);

  static final RegExp _whitespace = RegExp(r'\s+');

  /// Texto original completo da resposta.
  final String text;

  /// Palavras da resposta; os espaços entre elas não são armazenados como
  /// caracteres, pois a separação é representada pela própria lista.
  final List<List<AnswerCharacter>> words;

  /// Conjunto de letras normalizadas que precisam ser descobertas.
  final Set<String> letters;

  static List<AnswerCharacter> _parseWord(String word) => List.unmodifiable(
        word.runes.map((rune) => AnswerCharacter(String.fromCharCode(rune))),
      );

  @override
  String toString() => text;
}
