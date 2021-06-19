import 'package:flutter/cupertino.dart';

class CustomLine extends CustomPainter {
  final Offset startOffset;
  final List<Offset> endOffset;

  CustomLine({this.startOffset, this.endOffset});
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.5,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    for (int i = 0; i < endOffset.length; i++) {
      canvas.drawLine(
        startOffset,
        endOffset[i],
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
