import 'package:hangman_game/domain/letter_normalizer.dart';
import 'package:hangman_game/domain/models/answer.dart';
import 'package:hangman_game/domain/models/guess_outcome.dart';
import 'package:hangman_game/domain/models/hangman_entry.dart';
import 'package:hangman_game/domain/models/letter_state.dart';
import 'package:hangman_game/domain/models/round_status.dart';

/// Regras e estado de uma rodada do Jogo da Forca.
class HangmanRound {
  HangmanRound(this.entry, {this.maxErrors = defaultMaxErrors})
      : assert(maxErrors > 0, 'maxErrors deve ser positivo');

  /// Uma parte do boneco por erro: cabeça, tronco, dois braços e duas pernas.
  static const int defaultMaxErrors = 6;

  final HangmanEntry entry;
  final int maxErrors;

  final Set<String> _guessedLetters = <String>{};
  int _errors = 0;
  bool _hintUsed = false;

  Answer get answer => entry.answer;
  int get errors => _errors;
  bool get hintUsed => _hintUsed;
  Set<String> get guessedLetters => Set.unmodifiable(_guessedLetters);

  RoundStatus get status {
    if (_errors >= maxErrors) return RoundStatus.lost;
    if (answer.letters.every(_guessedLetters.contains)) return RoundStatus.won;
    return RoundStatus.inProgress;
  }

  bool get isFinished => status.isFinished;

  /// Caracteres não alfabéticos estão sempre visíveis; letras, somente
  /// depois de descobertas.
  bool isRevealed(AnswerCharacter character) =>
      !character.isLetter || _guessedLetters.contains(character.normalized);

  LetterState letterState(String letter) {
    final normalized = normalizeLetter(letter);
    if (!_guessedLetters.contains(normalized)) return LetterState.unused;
    return answer.letters.contains(normalized)
        ? LetterState.hit
        : LetterState.miss;
  }

  /// Aplica a tentativa à resposta completa (todas as palavras).
  GuessOutcome guess(String letter) {
    if (isFinished) return GuessOutcome.roundFinished;
    if (!isGuessableLetter(letter)) return GuessOutcome.invalid;

    final normalized = normalizeLetter(letter);
    if (!_guessedLetters.add(normalized)) return GuessOutcome.repeated;
    if (answer.letters.contains(normalized)) return GuessOutcome.hit;

    _errors++;
    return GuessOutcome.miss;
  }

  /// Registra o uso da dica. Retorna `true` apenas na primeira consulta,
  /// de modo que consultas repetidas não são contabilizadas novamente.
  bool useHint() {
    if (_hintUsed || isFinished) return false;
    _hintUsed = true;
    return true;
  }
}
