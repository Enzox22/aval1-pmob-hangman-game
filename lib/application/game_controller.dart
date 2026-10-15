import 'package:flutter/foundation.dart';
import 'package:hangman_game/application/entry_pool.dart';
import 'package:hangman_game/domain/models/answer_category.dart';
import 'package:hangman_game/domain/models/difficulty.dart';
import 'package:hangman_game/domain/models/guess_outcome.dart';
import 'package:hangman_game/domain/models/hangman_round.dart';
import 'package:hangman_game/domain/models/session_statistics.dart';

/// Estado da sessão: seleção atual, rodada em andamento e estatísticas.
///
/// Faz a ponte entre a interface e as regras do domínio, notificando os
/// widgets a cada mudança.
class GameController extends ChangeNotifier {
  GameController({required EntryPool pool, SessionStatistics? statistics})
      : _pool = pool,
        _statistics = statistics ?? SessionStatistics();

  final EntryPool _pool;
  final SessionStatistics _statistics;

  AnswerCategory? _category;
  Difficulty? _difficulty;
  HangmanRound? _round;
  bool _roundRegistered = false;

  List<AnswerCategory> get categories => _pool.categories;
  List<Difficulty> get difficulties => _pool.difficulties;
  AnswerCategory? get selectedCategory => _category;
  Difficulty? get selectedDifficulty => _difficulty;
  HangmanRound? get currentRound => _round;
  SessionStatistics get statistics => _statistics;

  bool get hasSelection => _category != null && _difficulty != null;

  int get totalForSelection {
    final category = _category;
    final difficulty = _difficulty;
    if (category == null || difficulty == null) return 0;
    return _pool.totalCount(category, difficulty);
  }

  int get remainingForSelection {
    final category = _category;
    final difficulty = _difficulty;
    if (category == null || difficulty == null) return 0;
    return _pool.remainingCount(category, difficulty);
  }

  /// Todas as respostas da combinação selecionada já foram utilizadas.
  bool get isSelectionExhausted =>
      totalForSelection > 0 && remainingForSelection == 0;

  bool get canStartRound => remainingForSelection > 0;

  void selectCategory(AnswerCategory category) {
    if (_category == category) return;
    _category = category;
    notifyListeners();
  }

  void selectDifficulty(Difficulty difficulty) {
    if (_difficulty == difficulty) return;
    _difficulty = difficulty;
    notifyListeners();
  }

  /// Inicia uma rodada com a seleção atual. Retorna `false` quando não há
  /// respostas inéditas para a combinação.
  bool startRound() {
    final category = _category;
    final difficulty = _difficulty;
    if (category == null || difficulty == null) return false;

    final entry = _pool.pick(category, difficulty);
    if (entry == null) return false;

    _round = HangmanRound(entry);
    _roundRegistered = false;
    notifyListeners();
    return true;
  }

  GuessOutcome guess(String letter) {
    final round = _round;
    if (round == null) return GuessOutcome.roundFinished;

    final outcome = round.guess(letter);
    _registerIfFinished(round);
    notifyListeners();
    return outcome;
  }

  void useHint() {
    final round = _round;
    if (round != null && round.useHint()) notifyListeners();
  }

  /// Libera novamente as respostas da combinação selecionada, por decisão
  /// explícita do usuário.
  void resetSelectionUsage() {
    final category = _category;
    final difficulty = _difficulty;
    if (category == null || difficulty == null) return;
    _pool.resetUsage(category, difficulty);
    notifyListeners();
  }

  /// Garante que cada rodada concluída seja contabilizada uma única vez.
  void _registerIfFinished(HangmanRound round) {
    if (_roundRegistered || !round.isFinished) return;
    _statistics.registerRound(round);
    _roundRegistered = true;
  }
}
