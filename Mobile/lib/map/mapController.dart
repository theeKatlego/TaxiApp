import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TaxiApp/map/hereMapControllerExtensionMethods.dart';

class MapController {
  BuildContext _context;
  HereMapController _hereMapController;
  List<MapMarker> _mapMarkerList = [];
  MapMarker _locationSelectedMapMarker;
  void Function(GeoCoordinates) _locationSelected;

  MapController(BuildContext context, HereMapController hereMapController,
      void Function(GeoCoordinates) locationSelected) {
    _context = context;
    _hereMapController = hereMapController;
    _locationSelected = locationSelected;

    _hereMapController.camera
        .lookAtPointWithDistance(GeoCoordinates(-28.4793, 24.6727), 3500000);

    double distanceToEarthInMeters = 2500;
    GeoCoordinates coordinates;
    Geolocator.getCurrentPosition()
        .then((position) =>
            coordinates = GeoCoordinates(position.latitude, position.longitude))
        .catchError((e) => _showDialog('Error', 'Failed to get your location.'))
        .whenComplete(() => {
              _hereMapController.camera.lookAtPointWithDistance(
                  coordinates, distanceToEarthInMeters),
              showAnchoredMapMarkers(coordinates)
            });

    // Setting a tap handler to pick markers from map.
    _setTapGestureHandler();
  }

  Future<void> showAnchoredMapMarkers(GeoCoordinates geoCoordinates) async {
    await _hereMapController
        .showAnchoredMapMarkers(geoCoordinates)
        .then((markers) => _mapMarkerList.addAll(markers));
  }

  void clearMap() {
    for (var mapMarker in _mapMarkerList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _mapMarkerList.clear();
  }

  Future<void> _showSelectedLocationMapMarkers(
      GeoCoordinates geoCoordinates) async {
    if (_locationSelectedMapMarker != null)
      _hereMapController.removeMapMarker(_locationSelectedMapMarker);
    await _hereMapController
        .showSelectedLocationMapMarkers(geoCoordinates, 3)
        .then((marker) => _locationSelectedMapMarker = marker);
  }

  void _setTapGestureHandler() {
    if (_locationSelected != null)
      _hereMapController.gestures.tapListener =
          TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
        var coordinates = _hereMapController.viewToGeoCoordinates(touchPoint);
        _locationSelected(coordinates);
        _showSelectedLocationMapMarkers(coordinates);
      });
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
