import 'package:TaxiApp/utils/snackBarShower.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/search.dart';
import 'package:TaxiApp/map/hereMapControllerExtensionMethods.dart';
import 'package:here_sdk/routing.dart' as here;

class FindTaxi extends StatefulWidget {
  Place departure;
  Place destination;

  FindTaxi(this.departure, this.destination, {Key key}) : super(key: key);

  @override
  _FindTaxiState createState() =>
      _FindTaxiState(departure: departure, destination: destination);
}

class _FindTaxiState extends State<FindTaxi> {
  BuildContext _context;

  var _routingEngine = new RoutingEngine();
  Place departure;
  Place destination;
  int durationInSeconds;
  int distanceInMeters;

  _FindTaxiState({@required this.departure, @required this.destination});

  @override
  Future<void> initState() {
    super.initState();
    var departureWaypoint = Waypoint.withDefaults(departure.geoCoordinates);
    var destinationWaypoint = Waypoint.withDefaults(destination.geoCoordinates);

    List<Waypoint> waypoints = [departureWaypoint, destinationWaypoint];

    _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
        (RoutingError routingError, List<here.Route> routeList) async {
      if (routingError == null) {
        here.Route route = routeList.first;
        setState(() {
          durationInSeconds = route.durationInSeconds;
          distanceInMeters = route.lengthInMeters;
        });
      } else {
        SnackBarShower.showSnackBar(
            context, "Coundn't estimate time and costs.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          HereMap(onMapCreated: _onMapCreated),
          Positioned(
            left: 10,
            top: 40,
            child: IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                onPressed: () => Navigator.of(context)
                    .pop({departure: departure, destination: destination})),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Wrap(
              children: <Widget>[
                Center(
                  child: Container(
                    width: width * 0.8,
                    child: Center(
                      child: Text(
                        "Finding a taxi",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                LinearProgressIndicator(),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Theme.of(context).accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: width * 0.8,
                      child: Text(
                        departure.address.addressText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Theme.of(context).accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: width * 0.8,
                      child: Text(destination.address.addressText,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      color: Theme.of(context).accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: width * 0.8,
                      child: Text(
                        "R 0.00 (estimate)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.more_time,
                      color: Theme.of(context).accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: width * 0.8,
                      child: Text(
                          durationInSeconds != null
                              ? '${(durationInSeconds / 60).toStringAsFixed(2)}. min (${(durationInSeconds / 60 / 60).toStringAsFixed(2)} hrs)  (estimate)'
                              : "",
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      color: Theme.of(context).accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: width * 0.8,
                      child: Text(
                          distanceInMeters != null
                              ? '${distanceInMeters / 1000} km  (estimate)'
                              : "",
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                Divider(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: Icon(Icons.cancel, size: 18),
                    label: Text("Cancel"),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future<void> _onMapCreated(HereMapController hereMapController) {
    var expansionUnits =
        departure.geoCoordinates.distanceTo(destination.geoCoordinates);
    var box = GeoBox.containingGeoCoordinates(
            [departure.geoCoordinates, destination.geoCoordinates])
        .expandedBy(
            expansionUnits, expansionUnits, expansionUnits, expansionUnits);

    hereMapController.camera.lookAtAreaWithOrientation(
        box, MapCameraOrientationUpdate.withDefaults());
    hereMapController.mapScene
        .loadSceneForMapScheme(MapScheme.normalDay, (MapError error) {});

    hereMapController
        .showAnchoredMapMarkers(departure.geoCoordinates)
        .then((markers) => {});
    hereMapController
        .showSelectedLocationMapMarkers(destination.geoCoordinates, 3)
        .then((marker) => {});
  }
}
