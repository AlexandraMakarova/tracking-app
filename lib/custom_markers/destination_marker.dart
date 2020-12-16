part of 'custom_markers.dart';

class DestinationMarkerPainter extends CustomPainter {
  final String description;
  final double metres;

  DestinationMarkerPainter(this.description, this.metres);

  @override
  void paint(Canvas canvas, Size size) {
    final double circleWhiteR = 20;
    final double circleGreenR = 7;

    Paint paint = new Paint()..color = Colors.lightGreen;

    canvas.drawCircle(
      Offset(circleWhiteR, size.height - circleWhiteR),
      20,
      paint,
    );

    paint.color = Colors.white;

    canvas.drawCircle(
      Offset(circleWhiteR, size.height - circleWhiteR),
      circleGreenR,
      paint,
    );

    final Path path = new Path();

    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    // White box
    final whiteBox = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(whiteBox, paint);

    // Green box
    paint.color = Colors.lightGreen;
    final greenBox = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(greenBox, paint);

    // Print text
    double kilometres = (((this.metres / 1000) * 100).floorToDouble()) / 100;

    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
        text: '$kilometres');

    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(0, 35));

    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'km');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);

    textPainter.paint(canvas, Offset(25, 67));

    // Location
    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w400),
        text: this.description);

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 2,
        ellipsis: '...')
      ..layout(
        maxWidth: size.width - 100,
      );

    textPainter.paint(canvas, Offset(90, 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
