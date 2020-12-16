part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool manualSelection;
  final List<SearchResult> historial;

  SearchState({
    this.manualSelection = false,
    List<SearchResult> historial,
  }) : this.historial = (historial == null) ? [] : historial;

  SearchState copyWith({
    bool manualSelection,
    List<SearchResult> historial,
  }) =>
      SearchState(
          manualSelection: manualSelection ?? this.manualSelection,
          historial: historial ?? this.historial);
}
