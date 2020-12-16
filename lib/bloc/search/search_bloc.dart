import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/search_result.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OnActivateManualMarker) {
      yield state.copyWith(manualSelection: true);
    } else if (event is OnDesactivateManualMarker) {
      yield state.copyWith(manualSelection: false);
    } else if (event is OnAddHistorial) {
      final isExist = state.historial
          .where((result) =>
              result.destinationName == event.result.destinationName)
          .length;

      if (isExist == 0) {
        final newHistorial = [...state.historial, event.result];
        yield state.copyWith(historial: newHistorial);
      }
    }
  }
}
