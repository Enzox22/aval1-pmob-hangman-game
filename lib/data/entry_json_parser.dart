import 'dart:convert';

import 'package:hangman_game/data/entry_data_exception.dart';
import 'package:hangman_game/domain/models/answer.dart';
import 'package:hangman_game/domain/models/answer_category.dart';
import 'package:hangman_game/domain/models/difficulty.dart';
import 'package:hangman_game/domain/models/hangman_entry.dart';

/// Converte o conteúdo JSON em objetos [HangmanEntry], validando cada campo
/// e convertendo `category` e `difficulty` para os tipos enumerados.
class EntryJsonParser {
  const EntryJsonParser();

  List<HangmanEntry> parse(String source) {
    final decoded = _decode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const EntryDataException('O JSON deve ser um objeto.');
    }
    final rawEntries = decoded['entries'];
    if (rawEntries is! List) {
      throw const EntryDataException('O campo "entries" deve ser uma lista.');
    }
    if (rawEntries.isEmpty) {
      throw const EntryDataException('O campo "entries" está vazio.');
    }
    return List.unmodifiable([
      for (var index = 0; index < rawEntries.length; index++)
        _parseEntry(rawEntries[index], index),
    ]);
  }

  Object? _decode(String source) {
    try {
      return jsonDecode(source);
    } on FormatException catch (error) {
      throw EntryDataException('JSON inválido: ${error.message}');
    }
  }

  HangmanEntry _parseEntry(Object? raw, int index) {
    if (raw is! Map<String, dynamic>) {
      throw EntryDataException('Entrada $index: formato inválido.');
    }
    return HangmanEntry(
      answer: _parseAnswer(raw['answer'], index),
      category: _parseEnum(
        AnswerCategory.values,
        raw['category'],
        'category',
        index,
      ),
      difficulty: _parseEnum(
        Difficulty.values,
        raw['difficulty'],
        'difficulty',
        index,
      ),
      hints: _parseHints(raw['hints'], index),
    );
  }

  Answer _parseAnswer(Object? raw, int index) {
    if (raw is! String) {
      throw EntryDataException('Entrada $index: "answer" deve ser um texto.');
    }
    try {
      return Answer(raw);
    } on FormatException catch (error) {
      throw EntryDataException('Entrada $index: ${error.message}');
    }
  }

  /// Converte o texto técnico do JSON (ex.: `humanBody`) no valor do enum.
  T _parseEnum<T extends Enum>(
    List<T> values,
    Object? raw,
    String field,
    int index,
  ) {
    for (final value in values) {
      if (value.name == raw) return value;
    }
    throw EntryDataException(
      'Entrada $index: valor inválido para "$field": $raw.',
    );
  }

  List<String> _parseHints(Object? raw, int index) {
    if (raw is! List || raw.isEmpty) {
      throw EntryDataException(
        'Entrada $index: "hints" deve ser uma lista não vazia.',
      );
    }
    return [
      for (final hint in raw)
        if (hint is String && hint.trim().isNotEmpty)
          hint.trim()
        else
          throw EntryDataException('Entrada $index: dica inválida.'),
    ];
  }
}
