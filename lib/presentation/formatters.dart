/// Formata uma taxa entre 0 e 1 como percentual (ex.: `0.5` → `50,0%`).
String formatPercent(double rate) {
  final percent = (rate * 100).toStringAsFixed(1).replaceAll('.', ',');
  return '$percent%';
}
