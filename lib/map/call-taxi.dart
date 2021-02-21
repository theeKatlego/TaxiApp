import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';

class CallTaxi extends StatefulWidget {
  Place departure;
  Place destination;

  CallTaxi(this.departure, this.destination, {Key key}) : super(key: key);

  @override
  _CallTaxiState createState() =>
      _CallTaxiState(departure: departure, destination: destination);
}

class _CallTaxiState extends State<CallTaxi> {
  BuildContext _context;
  Place departure;
  Place destination;

  _CallTaxiState({this.departure, this.destination});

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
                onPressed: () =>
                    Navigator.of(context).pop([departure, destination])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: ImageIcon(AssetImage("assets/images/town_hand.png"))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 115,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
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
              ],
            ),
          )),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    var box = GeoBox(departure.geoCoordinates, destination.geoCoordinates);
    hereMapController.camera.lookAtAreaWithOrientation(
        box, MapCameraOrientationUpdate.withDefaults());
    hereMapController.mapScene
        .loadSceneForMapScheme(MapScheme.normalDay, (MapError error) {});
  }
}
