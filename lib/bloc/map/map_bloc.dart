import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:maps_app/helpers/helpers.dart';
import 'package:meta/meta.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../themes/uber_style_map_theme.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(new MapState());

  //Map Controller
  GoogleMapController _mapController;

  //Polylines
  Polyline _myRoute = new Polyline(
    polylineId: PolylineId('my_route'),
    width: 3,
    color: Colors.transparent,
  );

  Polyline _myDestinationRoute = new Polyline(
    polylineId: PolylineId('my_destination_route'),
    width: 3,
    color: Colors.deepPurple[400],
  );

  void initMap(GoogleMapController controller) {
    if (!state.isMapReady) {
      this._mapController = controller;

      this._mapController.setMapStyle(jsonEncode(uberStyleMapTheme));

      add(OnMapLoaded());
    }
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapLoaded) {
      yield state.copyWith(isMapReady: true);
    } else if (event is OnMapLocationChange) {
      yield* this._onMapLocationChange(event);
    } else if (event is OnShowRoute) {
      yield* this._onShowRoute(event);
    } else if (event is OnFollowLocation) {
      yield* this._onFollowLocation(event);
    } else if (event is OnMapHasMoved) {
      yield state.copyWith(centralLocation: event.mapCenter);
    } else if (event is OnCreateRouteStartDestination) {
      yield* this._onCreateRouteStartDestination(event);
    }
  }

  Stream<MapState> _onMapLocationChange(OnMapLocationChange event) async* {
    if (state.followLocation) {
      this.moveCamera(event.location);
    }

    final points = [...this._myRoute.points, event.location];
    this._myRoute = this._myRoute.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._myRoute;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapState> _onShowRoute(OnShowRoute event) async* {
    if (!state.drawRoute) {
      this._myRoute = this._myRoute.copyWith(colorParam: Colors.deepPurple);
    } else {
      this._myRoute = this._myRoute.copyWith(colorParam: Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._myRoute;

    yield state.copyWith(
      drawRoute: !state.drawRoute,
      polylines: currentPolylines,
    );
  }

  Stream<MapState> _onFollowLocation(OnFollowLocation event) async* {
    if (!state.followLocation) {
      this.moveCamera(this._myRoute.points[this._myRoute.points.length - 1]);
    }
    yield state.copyWith(followLocation: !state.followLocation);
  }

  Stream<MapState> _onCreateRouteStartDestination(
      OnCreateRouteStartDestination event) async* {
    this._myDestinationRoute =
        this._myDestinationRoute.copyWith(pointsParam: event.coordinatesRoute);

    final currentPolylines = state.polylines;
    currentPolylines['my_destination_route'] = this._myDestinationRoute;

    //Icon Start
    // final startIcon = await getAssetImagemMarker();
    // final destinationIcon = await getNetworkImageMarker();
    final startIcon = await getStartMarkerIcon(event.duration.toInt());

    final destinationIcon =
        await getDestinationMarkerIcon(event.destinationName, event.distance);

    final markerStart = new Marker(
      anchor: Offset(0.0, 1.0),
      markerId: MarkerId('start'),
      position: event.coordinatesRoute[0],
      icon: startIcon,
      infoWindow: InfoWindow(
        title: 'My Location',
        snippet: 'Travel duration: ${(event.duration / 60).floor()} minutes',
        anchor: Offset(0.5, 0),
        onTap: () {
          print('infoWindowTap');
        },
      ),
    );

    double km = (((event.distance / 1000) * 100).floor().toDouble()) / 100;

    final markerDestination = new Marker(
        anchor: Offset(0.1, 0.9),
        markerId: MarkerId('destination'),
        position: event.coordinatesRoute[event.coordinatesRoute.length - 1],
        icon: destinationIcon,
        infoWindow: InfoWindow(
          title: event.destinationName,
          snippet: 'Distance: ${km} km',
          anchor: Offset(0.5, 0),
          onTap: () {
            print('infoWindowTap');
          },
        ));

    final newMarkers = {...state.markers};
    newMarkers['start'] = markerStart;
    newMarkers['destination'] = markerDestination;

    Future.delayed(Duration(microseconds: 300)).then((value) {
      // _mapController.showMarkerInfoWindow(MarkerId('start'));
      // _mapController.showMarkerInfoWindow(MarkerId('destination'));
    });

    yield state.copyWith(
      polylines: currentPolylines,
      markers: newMarkers,
    );
  }
}
