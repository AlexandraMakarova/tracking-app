import 'package:flutter/material.dart';
import '../custom_markers/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.deepPurple,
          child: CustomPaint(
            painter: StartMarkerPainter(250),
            // painter: DestinationMarkerPainter(
            //   'My home is here blablqblabalblablalbdsdgs sdgsdg s d gs',
            //   25039,
            // ),
          ),
        ),
      ),
    );
  }
}
