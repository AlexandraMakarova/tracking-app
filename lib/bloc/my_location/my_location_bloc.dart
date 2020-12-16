import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc() : super(MyLocationState());

  StreamSubscription<Position> _positionSubscription;

  void startFollow() {
    this._positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.lowest,
      distanceFilter: 10,
    ).listen((Position position) {
      final newLocation = new LatLng(position.latitude, position.longitude);
      add(OnLocationChange(newLocation));
    });
  }

  void stopFollow() {
    _positionSubscription?.cancel();
  }

  @override
  Stream<MyLocationState> mapEventToState(MyLocationEvent event) async* {
    if (event is OnLocationChange) {
      yield state.copyWith(
        locationExists: true,
        location: event.location,
      );
    }
  }
}
