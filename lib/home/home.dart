import 'package:TaxiApp/components/sideMenu.dart';
import 'package:TaxiApp/map/hereMapPage.dart';
import 'package:TaxiApp/map/itinerary.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:TaxiApp/style/theme.dart' as Theme;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Use _context only within the scope of this widget.
  BuildContext _context;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _context = context;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        drawer: SideMenu(),
        body: Stack(
          children: <Widget>[
            HereMap(onMapCreated: _onMapCreated),
            Positioned(
              left: 10,
              top: 40,
              child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onPressed: () {
                    _globalKey.currentState.openDrawer();
                  }),
            ),
            Positioned(
                top: height * 0.12,
                left: width * 0.1,
                child: ButtonTheme(
                  minWidth: width * 0.8,
                  height: 45,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: RaisedButton(
                      elevation: 20,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              color: Theme.Colors.accentColor,
                              width: 10,
                              height: 10,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Where to?'),
                          SizedBox(width: width * 0.5),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 450),
                                pageBuilder: (context, _, __) => Itinerary()));
                      }),
                ))
          ],
        ));
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.camera
        .lookAtPointWithDistance(GeoCoordinates(-28.4793, 24.6727), 10000);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        HereMapsPage(_context, hereMapController);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }
}
