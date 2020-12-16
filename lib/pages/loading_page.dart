import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/helpers.dart';
import './access_gps_page.dart';
import './map_page.dart';

class LoadingPage extends StatefulWidget {
  static const routeName = '/loading';

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacementNamed(context, MapPage.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsAndLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
    );
  }

  Future checkGpsAndLocation(BuildContext context) async {
    final permissionGPS = await Permission.location.isGranted;

    final gpsIsActive = await Geolocator.isLocationServiceEnabled();
    if (permissionGPS && gpsIsActive) {
      Navigator.pushReplacement(context, navigateFadeIn(context, MapPage()));
      return '';
    } else if (!permissionGPS) {
      Navigator.pushReplacement(
          context, navigateFadeIn(context, AccessGpsPage()));
      return 'GPS permissions are required';
    } else {
      return 'You should switch on GPS';
    }
  }
}
