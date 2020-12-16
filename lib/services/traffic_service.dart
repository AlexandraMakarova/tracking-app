import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import '../helpers/debouncer.dart';

import '../models/reverse_query_response.dart';
import '../models/geocoding_response.dart';
import '../models/driving_response.dart';

class TrafficService {
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();

  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  final StreamController<GeocodingResponse> _suggestionsStreamController =
      new StreamController<GeocodingResponse>.broadcast();

  Stream<GeocodingResponse> get suggestionsStream =>
      this._suggestionsStreamController.stream;

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _mapBoxApiKey =
      'pk.eyJ1IjoiYWxleG1ha2Fyb3ZhIiwiYSI6ImNraTB3anBkdDBkdnkyenBlaGlvY3VobmcifQ.k0Fk0GdTQODJqkNDilILEA';

  Future<DrivingResponse> getCoordinates(
      LatLng start, LatLng destination) async {
    final coordString =
        '${start.longitude},${start.latitude}; ${destination.longitude},${destination.latitude}';
    final url = '${this._baseUrlDir}/mapbox/driving/$coordString';

    final response = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'true',
      'access_token': this._mapBoxApiKey,
      'language': 'es',
    });

    final data = DrivingResponse.fromJson(response.data);
    return data;
  }

  Future<GeocodingResponse> getResultsByQuery(
      String search, LatLng proximity) async {
    final url = '${this._baseUrlGeo}/mapbox.places/$search.json';

    try {
      final response = await this._dio.get(url, queryParameters: {
        'access_token': this._mapBoxApiKey,
        'autocomplete': 'true',
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'language': 'es',
      });

      final geocodingResponse = geocodingResponseFromJson(response.data);
      return geocodingResponse;
    } catch (e) {
      return GeocodingResponse(features: []);
    }
  }

  void getSuggestiansByQuery(String search, LatLng proximity) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.getResultsByQuery(value, proximity);
      this._suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = search;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<ReverseQueryResponse> getCoordinatesInfo(
      LatLng destinationCoords) async {
    final url =
        '${this._baseUrlGeo}/mapbox.places/${destinationCoords.longitude}, ${destinationCoords.latitude}.json';

    final response = await this._dio.get(url, queryParameters: {
      'access_token': this._mapBoxApiKey,
      'language': 'es',
    });

    final data = reverseQueryResponseFromJson(response.data);
    return data;
  }
}
