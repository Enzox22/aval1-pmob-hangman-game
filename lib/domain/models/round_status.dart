/// Estado de uma rodada. Vitória e derrota são mutuamente exclusivas.
enum RoundStatus {
  inProgress,
  won,
  lost;

  bool get isFinished => this != RoundStatus.inProgress;
}
