import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/map/map_bloc.dart';
import '../bloc/my_location/my_location_bloc.dart';
import '../widgets/widgets.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyLocationBloc>().startFollow();
  }

  @override
  void dispose() {
    context.read<MyLocationBloc>().stopFollow();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MyLocationBloc, MyLocationState>(
            builder: (_, state) => createMap(state),
          ),
          Positioned(
            top: 15,
            child: SearchBar(),
          ),
          ManualMarker(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonLocation(),
          ButtonMyRoute(),
          ButtonFollowLocation(),
        ],
      ),
    );
  }

  Widget createMap(MyLocationState state) {
    if (!state.locationExists) return Center(child: Text('Locate...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    mapBloc.add(OnMapLocationChange(state.location));

    final initialCameraPosition = new CameraPosition(
      target: state.location,
      zoom: 15,
    );

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, _) {
        return GoogleMap(
          initialCameraPosition: initialCameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: mapBloc.initMap,
          polylines: mapBloc.state.polylines.values.toSet(),
          markers: mapBloc.state.markers.values.toSet(),
          onCameraMove: (initialCameraPosition) {
            mapBloc.add(OnMapHasMoved(initialCameraPosition.target));
          },
          // onCameraIdle: () {
          //   print('On CamaraIdle');
          // },
        );
      },
    );
  }
}
