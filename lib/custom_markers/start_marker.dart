part of 'custom_markers.dart';

class StartMarkerPainter extends CustomPainter {
  final int minutes;

  StartMarkerPainter(this.minutes);

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

    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    // White box
    final whiteBox = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(whiteBox, paint);

    // Green box
    paint.color = Colors.lightGreen;
    final greenBox = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(greenBox, paint);

    // Print text
    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: '$minutes');

    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 35));

    // Min
    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Min');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 67));

    // Location
    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w400),
        text: 'My location');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        maxWidth: size.width - 130,
      );

    textPainter.paint(canvas, Offset(150, 50));
  }

  @override
  bool shouldRepaint(StartMarkerPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(StartMarkerPainter oldDelegate) => false;
}
