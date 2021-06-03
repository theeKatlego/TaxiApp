import 'dart:typed_data';
import 'package:TaxiApp/utils/helperMethods.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

extension AddMarkers on HereMapController {
  Future<List<MapMarker>> showAnchoredMapMarkers(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Centered on location. Shown below the POI image to indicate the location.
    // The draw order is determined from what is first added to the map,
    // but since loading images is done async, we can make this explicit by setting
    // a draw order. High numbers are drawn on top of lower numbers.
    var circleMarker = await addCircleMapMarker(geoCoordinates, 0);

    // Anchored, pointing to location.
    var poiMarker = await addPOIMapMarker(geoCoordinates, drawOrder);
    return [circleMarker, poiMarker];
  }

  Future<MapMarker> addPOIMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    Uint8List imagePixelData = await loadFileAsUint8List('poi.png');
    var poiMapImage =
        MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);

    // By default, the anchor point is set to 0.5, 0.5 (= centered).
    // Here the bottom, middle position should point to the location.
    Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapMarker mapMarker =
        MapMarker.withAnchor(geoCoordinates, poiMapImage, anchor2D);
    mapMarker.drawOrder = drawOrder;

    Metadata metadata = new Metadata();
    metadata.setString("key_poi", "Metadata: This is a POI.");
    mapMarker.metadata = metadata;

    this.mapScene.addMapMarker(mapMarker);
    return mapMarker;
  }

  Future<MapMarker> addCircleMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    Uint8List imagePixelData = await loadFileAsUint8List('circle.png');
    var circleMapImage =
        MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);

    MapMarker mapMarker = MapMarker(geoCoordinates, circleMapImage);
    mapMarker.drawOrder = drawOrder;

    this.mapScene.addMapMarker(mapMarker);
    return mapMarker;
  }

  Future<MapMarker> showSelectedLocationMapMarkers(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    Uint8List imagePixelData = await loadFileAsUint8List('poi_hand.png');
    var photoMapImage =
        MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);

    // By default, the anchor point is set to 0.5, 0.5 (= centered).
    // Here the bottom, middle position should point to the location.
    Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapMarker mapMarker =
        MapMarker.withAnchor(geoCoordinates, photoMapImage, anchor2D);
    mapMarker.drawOrder = drawOrder;

    this.mapScene.addMapMarker(mapMarker);
    return mapMarker;
  }

  void removeMapMarker(MapMarker mapMarker) {
    this.mapScene.removeMapMarker(mapMarker);
  }

  void removeMapMarkers(List<MapMarker> mapMarkers) {
    for (var mapMarker in mapMarkers) this.mapScene.removeMapMarker(mapMarker);
  }

  void clearMap(List<MapMarker> mapMarkerList) {
    for (var mapMarker in mapMarkerList) {
      removeMapMarker(mapMarker);
    }
    mapMarkerList.clear();
  }
}
