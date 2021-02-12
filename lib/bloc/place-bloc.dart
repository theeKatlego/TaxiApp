import 'dart:async';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';

class PlaceBloc {
  StreamController<List<Place>> _controller =
      new StreamController<List<Place>>();

  void searchPlace(text) {
    if (text == null || text.trim() == "") return;
    var searchEngine = SearchEngine();

    var boxArea = GeoBox(
        GeoCoordinates(-34.2193, 18.4402), GeoCoordinates(-22.4956, 30.4593));
    var searchQuery = TextQuery.withBoxArea(text, boxArea);
    var searchOptions = SearchOptions(LanguageCode.enUs, 100);
    searchEngine.searchByText(searchQuery, searchOptions,
        (SearchError searchError, List<Place> places) {
      print(places);
      print(places.length);
      _controller.add(places);
      places.forEach((element) {
        print(element.title + ' ' + element.address.addressText);
      });
    });
  }

  Stream placeStream() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
