import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polyline/polyline.dart' as Poly;

import '../bloc/map/map_bloc.dart';
import '../bloc/my_location/my_location_bloc.dart';
import '../bloc/search/search_bloc.dart';

import '../helpers/helpers.dart';

import '../search/search_destination.dart';

import '../models/search_result.dart';

import '../services/traffic_service.dart';

part 'button_location.dart';
part 'button_my_route.dart';
part 'button_follow_location.dart';
part 'search_bar.dart';
part 'manual_marker.dart';
