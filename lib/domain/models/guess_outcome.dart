/// Resultado de uma tentativa de letra.
enum GuessOutcome {
  /// A letra está presente na resposta.
  hit,

  /// A letra não está presente na resposta (conta um erro).
  miss,

  /// A letra já havia sido escolhida; nada muda.
  repeated,

  /// O caractere não é uma letra; nada muda.
  invalid,

  /// A rodada já terminou; nenhuma tentativa é aceita.
  roundFinished,
}
