/// Funções usadas exclusivamente para comparar letras ignorando acentuação.
///
/// A grafia original da resposta nunca é alterada: a normalização serve
/// apenas para que, por exemplo, a tentativa `A` corresponda a `Ã`.
library;

const Map<String, String> _accentedLetters = {
  'À': 'A',
  'Á': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Ä': 'A',
  'È': 'E',
  'É': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'Ì': 'I',
  'Í': 'I',
  'Î': 'I',
  'Ï': 'I',
  'Ò': 'O',
  'Ó': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ö': 'O',
  'Ù': 'U',
  'Ú': 'U',
  'Û': 'U',
  'Ü': 'U',
  'Ç': 'C',
  'Ñ': 'N',
};

final RegExp _baseLetterPattern = RegExp(r'^[A-Z]$');

/// Retorna [character] em maiúscula e sem acento (ex.: `ã` → `A`).
String normalizeLetter(String character) {
  final upperCase = character.toUpperCase();
  return _accentedLetters[upperCase] ?? upperCase;
}

/// Indica se [character] é uma letra, ou seja, algo que pode ser usado
/// como tentativa. Espaços, hífens e pontuação retornam `false`.
bool isGuessableLetter(String character) =>
    _baseLetterPattern.hasMatch(normalizeLetter(character));
