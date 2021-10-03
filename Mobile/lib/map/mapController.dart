import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TaxiApp/map/hereMapControllerExtensionMethods.dart';

class MapController {
  BuildContext _context;
  HereMapController _hereMapController;
  MapMarker _locationSelectedMapMarker;
  List<MapMarker> _poiMapMarker;
  void Function(GeoCoordinates) _locationSelected;

  static const int CircleMapMarkerDrawOrderPossition = 0;
  static const int POIMapMarkerDrawOrderPossition = 1;
  static const int SelectedLocationMapMarkersDrawOrderPossition = 3;

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
        .catchError((e) {
      _showDialog('Error', 'Failed to get your location.');
    }).whenComplete(() => {
              _hereMapController.camera.lookAtPointWithDistance(
                  coordinates, distanceToEarthInMeters),
              showAnchoredMapMarkers(coordinates)
            });

    // Setting a tap handler to pick markers from map.
    _setTapGestureHandler();
  }

  Future<void> showAnchoredMapMarkers(GeoCoordinates geoCoordinates) async {
    if (_poiMapMarker != null && _poiMapMarker.length >= 0)
      for (var mapMarker in _poiMapMarker)
        _hereMapController.mapScene.removeMapMarker(mapMarker);

    await _hereMapController
        .showAnchoredMapMarkers(geoCoordinates, POIMapMarkerDrawOrderPossition)
        .then((marker) => _poiMapMarker = marker);
  }

  void clearMap() {
    for (var mapMarker in _poiMapMarker)
      _hereMapController.mapScene.removeMapMarker(mapMarker);

    _hereMapController.mapScene.removeMapMarker(_locationSelectedMapMarker);
  }

  Future<void> showSelectedLocationMapMarkers(
      GeoCoordinates geoCoordinates) async {
    if (_locationSelectedMapMarker != null)
      _hereMapController.removeMapMarker(_locationSelectedMapMarker);
    await _hereMapController
        .showSelectedLocationMapMarkers(
            geoCoordinates, SelectedLocationMapMarkersDrawOrderPossition)
        .then((marker) => _locationSelectedMapMarker = marker);
  }

  void _setTapGestureHandler() {
    if (_locationSelected != null)
      _hereMapController.gestures.tapListener =
          TapListener((Point2D touchPoint) {
        var coordinates = _hereMapController.viewToGeoCoordinates(touchPoint);
        _locationSelected(coordinates);
        showSelectedLocationMapMarkers(coordinates);
      });
  }

  MapMarker getSelectedMapMarker() {
    return _locationSelectedMapMarker;
  }

  List<MapMarker> getPoiMapMarker() {
    return _poiMapMarker;
  }

  HereMapController getHereMapController() {
    return _hereMapController;
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
            TextButton(
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
