import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman_game/app.dart';
import 'package:hangman_game/data/asset_entry_repository.dart';

void main() {
  runApp(HangmanApp(repository: AssetEntryRepository(bundle: rootBundle)));
}
