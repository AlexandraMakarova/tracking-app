part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.manualSelection) {
          return Container();
        } else {
          return FadeInDown(
            duration: Duration(microseconds: 300),
            child: buildSearchbar(context),
          );
        }
      },
    );
  }

  Widget buildSearchbar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximity = context.read<MyLocationBloc>().state.location;
            final historial = context.read<SearchBloc>().state.historial;
            // print('Searching....');
            final SearchResult result = await showSearch(
                context: context,
                delegate: SearchDestination(proximity, historial));
            this.returnSearch(context, result);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 13,
            ),
            width: double.infinity,
            child: Text(
              'Where do you want to get',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: <BoxShadow>[
                  (BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ))
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> returnSearch(BuildContext context, SearchResult result) async {
    if (result.cancelled) return;

    if (result.manual) {
      context.read<SearchBloc>().add(OnActivateManualMarker());
      return;
    }
    loadingAlert(context);

    final trafficService = new TrafficService();
    final mapBloc = context.read<MapBloc>();

    final start = context.read<MyLocationBloc>().state.location;
    final destination = result.position;

    final drivingResponse =
        await trafficService.getCoordinates(start, destination);

    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;
    final destinationName = result.destinationName;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> coordinatesRoute = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();

    mapBloc.add(OnCreateRouteStartDestination(
      coordinatesRoute,
      distance,
      duration,
      destinationName,
    ));

    Navigator.of(context).pop();

    final searchBloc = context.read<SearchBloc>();
    searchBloc.add(OnAddHistorial(result));
  }
}
