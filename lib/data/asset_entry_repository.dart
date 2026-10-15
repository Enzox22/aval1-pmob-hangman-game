import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:hangman_game/data/entry_data_exception.dart';
import 'package:hangman_game/data/entry_json_parser.dart';
import 'package:hangman_game/domain/models/hangman_entry.dart';
import 'package:hangman_game/domain/repositories/entry_repository.dart';

/// Carrega as entradas a partir do arquivo JSON declarado nos assets.
class AssetEntryRepository implements EntryRepository {
  const AssetEntryRepository({
    required AssetBundle bundle,
    this.assetPath = defaultAssetPath,
    EntryJsonParser parser = const EntryJsonParser(),
  })  : _bundle = bundle,
        _parser = parser;

  static const String defaultAssetPath = 'assets/data/hangman_entries.json';

  final AssetBundle _bundle;
  final EntryJsonParser _parser;
  final String assetPath;

  @override
  Future<List<HangmanEntry>> loadEntries() async {
    final source = await _readAsset();
    return _parser.parse(source);
  }

  Future<String> _readAsset() async {
    try {
      return await _bundle.loadString(assetPath);
    } on FlutterError {
      throw EntryDataException('Não foi possível ler o arquivo $assetPath.');
    }
  }
}
