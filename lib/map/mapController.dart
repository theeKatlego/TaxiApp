import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:geolocator/geolocator.dart';

class MapController {
  BuildContext _context;
  HereMapController _hereMapController;
  List<MapMarker> _mapMarkerList = [];
  MapMarker _locationSelectedMapMarkerList;
  MapImage _poiMapImage;
  MapImage _photoMapImage;
  MapImage _circleMapImage;
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

  void showAnchoredMapMarkers(GeoCoordinates geoCoordinates) {
    // Centered on location. Shown below the POI image to indicate the location.
    // The draw order is determined from what is first added to the map,
    // but since loading images is done async, we can make this explicit by setting
    // a draw order. High numbers are drawn on top of lower numbers.
    _addCircleMapMarker(geoCoordinates, 0);

    // Anchored, pointing to location.
    _addPOIMapMarker(geoCoordinates, 1);
  }

  void clearMap() {
    for (var mapMarker in _mapMarkerList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _mapMarkerList.clear();
  }

  Future<void> _addPOIMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('poi.png');
      _poiMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    // By default, the anchor point is set to 0.5, 0.5 (= centered).
    // Here the bottom, middle position should point to the location.
    Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapMarker mapMarker =
        MapMarker.withAnchor(geoCoordinates, _poiMapImage, anchor2D);
    mapMarker.drawOrder = drawOrder;

    Metadata metadata = new Metadata();
    metadata.setString("key_poi", "Metadata: This is a POI.");
    mapMarker.metadata = metadata;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);
  }

  Future<void> _showSelectedLocationMapMarkers(
      GeoCoordinates geoCoordinates) async {
    if (_locationSelectedMapMarkerList != null)
      _hereMapController.mapScene
          .removeMapMarker(_locationSelectedMapMarkerList);

    // Reuse existing MapImage for new map markers.
    if (_photoMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('here_car.png');
      _photoMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _photoMapImage);
    mapMarker.drawOrder = 3;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _locationSelectedMapMarkerList = mapMarker;
  }

  Future<void> _addCircleMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_circleMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('circle.png');
      _circleMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _circleMapImage);
    mapMarker.drawOrder = drawOrder;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);
  }

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/images/' + fileName);
    return Uint8List.view(fileData.buffer);
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
