import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:TaxiApp/models/Coordinates.dart';

class LocationBloc {
  StreamController<Coordinates> _getCurrentLocationCoordinatesController =
      new StreamController<Coordinates>();
  StreamSubscription<Position> _positionStream;

  Future<Coordinates> getCurrentLocationCoordinates() async {
    Coordinates coordinates;
    return Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            forceAndroidLocationManager: true)
        .then((position) => coordinates = Coordinates(
            latitude: position.latitude, longitude: position.longitude))
        .catchError((e) => {})
        .whenComplete(() => coordinates);
  }

  void getCurrentLocationCoordinatesStream() {
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            forceAndroidLocationManager: true)
        .listen((Position position) {
      _getCurrentLocationCoordinatesController.add(Coordinates(
          latitude: position.latitude, longitude: position.longitude));
    });
  }

  Stream currentLocationCoordinatesStream() {
    return _getCurrentLocationCoordinatesController.stream;
  }

  void cancelCurrentLocationCoordinatesStream() {
    _positionStream.cancel();
  }

  void dispose() {
    _getCurrentLocationCoordinatesController.close();
    _positionStream.cancel();
  }
}
