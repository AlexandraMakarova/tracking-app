import 'package:flutter/material.dart';
import './pages/loading_page.dart';
import './pages/map_page.dart';
import './pages/access_gps_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoadingPage(),
        routes: {
          MapPage.routeName: (_) => MapPage(),
          LoadingPage.routeName: (_) => LoadingPage(),
          AccessGpsPage.routeName: (_) => AccessGpsPage(),
        });
  }
}
