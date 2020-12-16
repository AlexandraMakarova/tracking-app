part of 'map_bloc.dart';

@immutable
class MapState {
  final bool isMapReady;
  final bool drawRoute;
  final bool followLocation;
  final LatLng centralLocation;

  //Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapState({
    this.isMapReady = false,
    this.drawRoute = false,
    this.followLocation = false,
    this.centralLocation,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers,
  })  : this.polylines = polylines ?? new Map(),
        this.markers = markers ?? new Map();

  MapState copyWith({
    bool isMapReady,
    bool drawRoute,
    bool followLocation,
    LatLng centralLocation,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers,
  }) =>
      MapState(
        isMapReady: isMapReady ?? this.isMapReady,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        centralLocation: centralLocation ?? this.centralLocation,
        followLocation: followLocation ?? this.followLocation,
        drawRoute: drawRoute ?? this.drawRoute,
      );
}
