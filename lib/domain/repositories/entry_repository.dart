import 'package:hangman_game/domain/models/hangman_entry.dart';

/// Fonte das entradas do jogo. A implementação concreta fica na camada de
/// dados, de modo que o domínio não depende de Flutter nem de JSON.
abstract interface class EntryRepository {
  Future<List<HangmanEntry>> loadEntries();
}
