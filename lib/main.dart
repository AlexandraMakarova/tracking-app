import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maps_app/pages/test_marker_page.dart';

import './bloc/map/map_bloc.dart';
import './bloc/my_location/my_location_bloc.dart';
import './bloc/search/search_bloc.dart';

import './pages/access_gps_page.dart';
import './pages/loading_page.dart';
import './pages/map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MapBloc(),
        ),
        BlocProvider(
          create: (_) => MyLocationBloc(),
        ),
        BlocProvider(
          create: (_) => SearchBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: LoadingPage(),
          // home: TestMarkerPage(),
          routes: {
            MapPage.routeName: (_) => MapPage(),
            LoadingPage.routeName: (_) => LoadingPage(),
            AccessGpsPage.routeName: (_) => AccessGpsPage(),
          }),
    );
  }
}
