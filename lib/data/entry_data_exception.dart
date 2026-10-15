/// Erro de carregamento ou de inconsistência no arquivo de dados.
class EntryDataException implements Exception {
  const EntryDataException(this.message);

  final String message;

  @override
  String toString() => 'EntryDataException: $message';
}
