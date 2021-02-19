import 'dart:async';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';
import 'package:TaxiApp/bloc/location-bloc.dart';

class PlaceBloc {
  final searchEngine = SearchEngine();
  final searchOptions = SearchOptions(LanguageCode.enUs, 100);
  StreamController<List<Place>> _searchPlaceController =
      new StreamController<List<Place>>();

  void searchPlace(text) {
    if (text == null || text.trim() == "") return;

    var boxArea = GeoBox(
        GeoCoordinates(-34.2193, 18.4402), GeoCoordinates(-22.4956, 30.4593));
    var searchQuery = TextQuery.withBoxArea(text, boxArea);
    searchEngine.searchByText(searchQuery, searchOptions,
        (SearchError searchError, List<Place> places) {
      _searchPlaceController.add(places);
    });
  }

  void getAddressForCurrentCoordinates(
      void Function(Place) onSearchCompleted) async {
    GeoCoordinates coordinates;
    LocationBloc()
        .getCurrentLocationCoordinates()
        .then((currentCoordinates) => {
              coordinates = GeoCoordinates(
                  currentCoordinates.latitude, currentCoordinates.longitude)
            })
        .whenComplete(() => {
              searchEngine.searchByCoordinates(coordinates, searchOptions,
                  (SearchError searchError, List<Place> places) {
                if (searchError == null) onSearchCompleted(places[0]);
              })
            });
  }

  void getAddressForCoordinates(GeoCoordinates coordinates,
      void Function(Place) onSearchCompleted) async {
    searchEngine.searchByCoordinates(coordinates, searchOptions,
        (SearchError searchError, List<Place> places) {
      if (searchError == null) onSearchCompleted(places[0]);
    });
  }

  Stream placeStream() {
    return _searchPlaceController.stream;
  }

  void dispose() {
    _searchPlaceController.close();
  }
}
