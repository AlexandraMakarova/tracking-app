part of 'widgets.dart';

class ManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.manualSelection) {
          return _BuildManualMarker();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            duration: Duration(milliseconds: 150),
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.deepPurple[400],
                  ),
                  onPressed: () {
                    context.read<SearchBloc>().add(OnDesactivateManualMarker());
                  }),
            ),
          ),
        ),
        Center(
          child: Transform.translate(
              offset: Offset(0, -12),
              child: BounceInDown(
                from: 200,
                child: Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.deepPurple[600],
                ),
              )),
        ),
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 120,
              child: Text(
                'Confirm Destination',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.deepPurple[800],
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                this.calculateDestination(context);
              },
            ),
          ),
        )
      ],
    );
  }

  void calculateDestination(BuildContext context) async {
    loadingAlert(context);

    final trafficService = new TrafficService();
    final mapBloc = context.read<MapBloc>();

    final start = context.read<MyLocationBloc>().state.location;
    final destination = mapBloc.state.centralLocation;

    final reverseQueryResponse =
        await trafficService.getCoordinatesInfo(destination);
    final trafficResponse =
        await trafficService.getCoordinates(start, destination);
    final geometry = trafficResponse.routes[0].geometry;
    final duration = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;
    final destinationName = reverseQueryResponse.features[0].text;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> coordinatesRoute =
        points.map((point) => LatLng(point[0], point[1])).toList();
    mapBloc.add(OnCreateRouteStartDestination(
      coordinatesRoute,
      distance,
      duration,
      destinationName,
    ));

    Navigator.of(context).pop();
    context.read<SearchBloc>().add(OnDesactivateManualMarker());
  }
}
