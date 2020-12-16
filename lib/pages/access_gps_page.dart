import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './loading_page.dart';
import './map_page.dart';

class AccessGpsPage extends StatefulWidget {
  static const routeName = '/access_gps';

  @override
  _AccessGpsPageState createState() => _AccessGpsPageState();
}

class _AccessGpsPageState extends State<AccessGpsPage>
    with WidgetsBindingObserver {
  bool popup = false;

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
    if (state == AppLifecycleState.resumed && !popup) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, LoadingPage.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This app needs a GPS access permission'),
            MaterialButton(
              child:
                  Text('Request access', style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 1,
              splashColor: Colors.transparent,
              onPressed: () async {
                final status = await Permission.location.request();
                this.accessGPS(status);
              },
            ),
          ],
        ),
      ),
    );
  }

  void accessGPS(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, MapPage.routeName);
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.undetermined:
        openAppSettings();
    }
  }
}
