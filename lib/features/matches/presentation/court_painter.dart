import 'package:material_ui/material_ui.dart';

class CourtPainter extends CustomPainter {
  const CourtPainter({required this.courtColor, required this.lineColor});

  final Color courtColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final courtPaint = Paint()..color = courtColor;
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final court = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );
    canvas.drawRRect(court, courtPaint);
    canvas.drawRRect(court, linePaint);

    //line fo net
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    //line for serving
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    return oldDelegate.courtColor != courtColor ||
        oldDelegate.lineColor != lineColor;
  }
}
