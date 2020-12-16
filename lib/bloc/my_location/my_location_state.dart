part of 'my_location_bloc.dart';

@immutable
class MyLocationState {
  final bool follow;
  final bool locationExists;
  final LatLng location;

  MyLocationState({
    this.follow = true,
    this.locationExists = false,
    this.location,
  });

  MyLocationState copyWith({
    bool follow,
    bool locationExists,
    LatLng location,
  }) =>
      new MyLocationState(
        follow: follow ?? this.follow,
        locationExists: locationExists ?? this.locationExists,
        location: location ?? this.location,
      );
}
