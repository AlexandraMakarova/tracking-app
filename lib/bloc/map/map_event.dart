part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapLoaded extends MapEvent {}

class OnShowRoute extends MapEvent {}

class OnFollowLocation extends MapEvent {}

class OnCreateRouteStartDestination extends MapEvent {
  final List<LatLng> coordinatesRoute;
  final double distance;
  final double duration;
  final String destinationName;

  OnCreateRouteStartDestination(this.coordinatesRoute, this.distance,
      this.duration, this.destinationName);
}

class OnMapLocationChange extends MapEvent {
  final LatLng location;
  OnMapLocationChange(this.location);
}

class OnMapHasMoved extends MapEvent {
  final LatLng mapCenter;

  OnMapHasMoved(this.mapCenter);
}
