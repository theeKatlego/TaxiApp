import 'dart:async';

import 'package:TaxiApp/models/place.dart';
import 'package:TaxiApp/providers/place.dart';

class PlaceBloc {
  StreamController<List<Place>> _controller =
      new StreamController<List<Place>>();

  void searchPlace(text) {
    if (text != null || text != "") {
      getLocation(text).then((res) {
        _controller.add(res);
      }).catchError((error) {
        print(error);
      });
    }
  }

  Stream placeStream() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
