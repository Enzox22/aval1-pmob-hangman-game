import 'package:hangman_game/domain/models/hangman_round.dart';
import 'package:hangman_game/domain/models/round_status.dart';

/// Estatísticas acumuladas enquanto o aplicativo está em execução.
class SessionStatistics {
  int _wins = 0;
  int _losses = 0;
  int _totalErrors = 0;
  int _hintsUsed = 0;

  int get wins => _wins;
  int get losses => _losses;
  int get totalErrors => _totalErrors;
  int get hintsUsed => _hintsUsed;
  int get completedRounds => _wins + _losses;

  /// Percentuais calculados sobre as rodadas concluídas (de 0 a 1).
  double get winRate => _rateOf(_wins);
  double get lossRate => _rateOf(_losses);

  double _rateOf(int count) =>
      completedRounds == 0 ? 0.0 : count / completedRounds;

  /// Contabiliza uma rodada concluída.
  void registerRound(HangmanRound round) {
    switch (round.status) {
      case RoundStatus.won:
        _wins++;
      case RoundStatus.lost:
        _losses++;
      case RoundStatus.inProgress:
        throw StateError('Somente rodadas concluídas podem ser registradas.');
    }
    _totalErrors += round.errors;
    if (round.hintUsed) _hintsUsed++;
  }
}
