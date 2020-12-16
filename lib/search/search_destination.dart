import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import '../models/geocoding_response.dart';
import '../models/search_result.dart';
import '../services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximity;
  final List<SearchResult> historial;

  SearchDestination(this.proximity, this.historial)
      : this.searchFieldLabel = 'Search destination',
        this._trafficService = new TrafficService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => this.close(context, SearchResult(cancelled: true)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return this._buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Set destination manually'),
            onTap: () {
              this.close(context, SearchResult(cancelled: false, manual: true));
            },
          ),
          ...this
              .historial
              .map((result) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(result.destinationName),
                    subtitle: Text(result.description),
                    onTap: () {
                      this.close(context, result);
                    },
                  ))
              .toList()
        ],
      );
    }

    return this._buildResultsSuggestions();
  }

  Widget _buildResultsSuggestions() {
    if (this.query == 0) {
      return Container();
    }

    this
        ._trafficService
        .getSuggestiansByQuery(this.query.trim(), this.proximity);

    return StreamBuilder(
      stream: this._trafficService.suggestionsStream,
      builder:
          (BuildContext context, AsyncSnapshot<GeocodingResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final places = snapshot.data.features;

        if (places.length == 0) {
          return ListTile(
            title: Text('No results with $query'),
          );
        }
        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: (_, index) => Divider(),
          itemBuilder: (_, index) {
            final place = places[index];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(place.textEs),
              subtitle: Text(place.placeNameEs),
              onTap: () {
                this.close(
                    context,
                    SearchResult(
                      cancelled: false,
                      manual: false,
                      position: LatLng(place.center[1], place.center[0]),
                      destinationName: place.textEs,
                      description: place.placeNameEs,
                    ));
              },
            );
          },
        );
      },
    );
  }
}
