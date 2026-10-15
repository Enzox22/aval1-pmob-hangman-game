import 'package:flutter/material.dart';

/// Forca desenhada progressivamente: a estrutura aparece desde o início e
/// cada erro acrescenta uma parte do boneco (RF08).
class HangmanDrawing extends StatelessWidget {
  const HangmanDrawing({
    super.key,
    required this.errors,
    required this.maxErrors,
    required this.isLost,
    required this.height,
  });

  final int errors;
  final int maxErrors;
  final bool isLost;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Forca com $errors de $maxErrors partes desenhadas',
      child: SizedBox(
        height: height,
        child: Center(
          child: AspectRatio(
            aspectRatio: 0.85,
            child: CustomPaint(
              painter: _HangmanPainter(
                visibleParts: errors,
                gallowsColor: scheme.onSurfaceVariant,
                figureColor: isLost ? scheme.error : scheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HangmanPainter extends CustomPainter {
  _HangmanPainter({
    required this.visibleParts,
    required this.gallowsColor,
    required this.figureColor,
  });

  final int visibleParts;
  final Color gallowsColor;
  final Color figureColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = (w * 0.035).clamp(2.0, 6.0).toDouble();

    final gallows = Paint()
      ..color = gallowsColor
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final figure = Paint()
      ..color = figureColor
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Estrutura da forca.
    canvas
      ..drawLine(Offset(w * 0.1, h * 0.95), Offset(w * 0.9, h * 0.95), gallows)
      ..drawLine(Offset(w * 0.25, h * 0.95), Offset(w * 0.25, h * 0.05), gallows)
      ..drawLine(Offset(w * 0.25, h * 0.05), Offset(w * 0.65, h * 0.05), gallows)
      ..drawLine(Offset(w * 0.25, h * 0.18), Offset(w * 0.38, h * 0.05), gallows)
      ..drawLine(Offset(w * 0.65, h * 0.05), Offset(w * 0.65, h * 0.15), gallows);

    final headRadius = h * 0.08;
    final headCenter = Offset(w * 0.65, h * 0.15 + headRadius);
    final neck = Offset(w * 0.65, h * 0.15 + headRadius * 2);
    final hip = Offset(w * 0.65, h * 0.58);
    final shoulder = Offset(w * 0.65, h * 0.36);

    // Cada entrada corresponde a um erro, na ordem do enunciado.
    final parts = <void Function()>[
      () => canvas.drawCircle(headCenter, headRadius, figure),
      () => canvas.drawLine(neck, hip, figure),
      () => canvas.drawLine(shoulder, Offset(w * 0.5, h * 0.47), figure),
      () => canvas.drawLine(shoulder, Offset(w * 0.8, h * 0.47), figure),
      () => canvas.drawLine(hip, Offset(w * 0.52, h * 0.78), figure),
      () => canvas.drawLine(hip, Offset(w * 0.78, h * 0.78), figure),
    ];
    for (final drawPart in parts.take(visibleParts)) {
      drawPart();
    }
  }

  @override
  bool shouldRepaint(_HangmanPainter oldDelegate) =>
      oldDelegate.visibleParts != visibleParts ||
      oldDelegate.gallowsColor != gallowsColor ||
      oldDelegate.figureColor != figureColor;
}
