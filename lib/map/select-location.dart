import 'package:TaxiApp/map/mapController.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
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
                onPressed: () => Navigator.of(context).pop()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: Icon(Icons.arrow_forward)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 115,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "Confirm location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text("Move the map"),
              ],
            ),
          )),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.camera
        .lookAtPointWithDistance(GeoCoordinates(-28.4793, 24.6727), 10000);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        MapController(_context, hereMapController);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }
}
