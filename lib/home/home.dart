import 'package:TaxiApp/bloc/place-bloc.dart';
import 'package:TaxiApp/components/sideMenu.dart';
import 'package:TaxiApp/map/call-taxi.dart';
import 'package:TaxiApp/map/mapController.dart';
import 'package:TaxiApp/map/itinerary.dart';
import 'package:TaxiApp/style/theme.dart' as namelaTheme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Use _context only within the scope of this widget.
  BuildContext _context;
  Place _selectedLocation;
  Place currentLocation;

  @override
  void initState() {
    super.initState();
    PlaceBloc().getAddressForCurrentCoordinates((Place currentLocationAddress) {
      setState(() {
        currentLocation = currentLocationAddress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          HereMap(onMapCreated: _onMapCreated),
          Positioned(
              top: height * 0.12,
              left: 20,
              child: ButtonTheme(
                minWidth: width * 0.8,
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: RaisedButton(
                  elevation: 20,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 450),
                            pageBuilder: (context, _, __) =>
                                Itinerary(null, null)));
                  },
                  child: SizedBox(
                    width: width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.place,
                          color: Theme.of(context).accentColor,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: width * 0.7,
                          child: Text(
                            _selectedLocation == null
                                ? 'Where to?'
                                : _selectedLocation.address.addressText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
      floatingActionButton: _selectedLocation != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 450),
                        pageBuilder: (context, _, __) =>
                            CallTaxi(currentLocation, _selectedLocation)));
              },
              child: Icon(Icons.arrow_forward),
              backgroundColor: Theme.of(context).accentColor,
              elevation: 12,
            )
          : null,
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.camera
        .lookAtPointWithDistance(GeoCoordinates(-28.4793, 24.6727), 10000);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        MapController(_context, hereMapController,
            (GeoCoordinates coordinates) => _locationSelected(coordinates));
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  void _locationSelected(GeoCoordinates coordinates) {
    PlaceBloc().getAddressForCoordinates(
        coordinates, (Place place) => _showSelectedLocationAddress(place));
  }

  void _showSelectedLocationAddress(Place place) {
    setState(() {
      _selectedLocation = place;
    });
  }
}

class HomeDrawerContent extends DrawerContent {
  HomeDrawerContent({Key key, this.title});
  final String title;
  @override
  _HomeDrawerContentState createState() => _HomeDrawerContentState();
}

class _HomeDrawerContentState extends State<HomeDrawerContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Home(),
          Positioned(
            left: 10,
            top: 40,
            child: IconButton(
                color: namelaTheme.Colors.onPrimary,
                icon: Icon(
                  Icons.menu,
                  size: 30,
                ),
                onPressed: widget.onMenuPressed),
          ),
        ],
      ),
    );
  }
}

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: HomeDrawerContent(
        title: 'main',
      ),
      items: [
        DrawerItem(
          text: Text('Trip History',
              style: TextStyle(color: namelaTheme.Colors.primaryColor)),
          icon: Icon(Icons.history, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'Trip History',
          ),
        ),
        DrawerItem(
          text: Text(
            'Payment',
            style: TextStyle(color: namelaTheme.Colors.primaryColor),
          ),
          icon: Icon(Icons.payment, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'Payment',
          ),
        ),
        DrawerItem(
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (_) => MasterPage()));
          },
          text: Text(
            'Feedback',
            style: TextStyle(color: namelaTheme.Colors.primaryColor),
          ),
          icon: Icon(Icons.feedback, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'Feedback',
          ),
        ),
        DrawerItem(
          text: Text(
            'Invite',
            style: TextStyle(color: namelaTheme.Colors.primaryColor),
          ),
          icon: Icon(Icons.share, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'invite',
          ),
        ),
        DrawerItem(
          text: Text(
            'Support',
            style: TextStyle(color: namelaTheme.Colors.primaryColor),
          ),
          icon: Icon(Icons.headset_mic, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'Support',
          ),
        ),
        DrawerItem(
          text: Text(
            'Settngs',
            style: TextStyle(color: namelaTheme.Colors.primaryColor),
          ),
          icon: Icon(Icons.settings, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'Settngs',
          ),
        ),
        DrawerItem(
          text: Text(
            'About',
            style: TextStyle(color: namelaTheme.Colors.primaryColor),
          ),
          icon: Icon(Icons.info, color: namelaTheme.Colors.primaryColor),
          page: HomeDrawerContent(
            title: 'About',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiddenDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      "https://media.gq.com/photos/5c9d404a8d459e781a1333b5/3:4/w_971,h_1295,c_limit/How-to-Get-Jon-Snow's-Hair-game-of-thrones-gq-grooming.jpg"),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'John Snow',
                style: TextStyle(
                    color: namelaTheme.Colors.primaryColor, fontSize: 20),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: namelaTheme.Colors.primaryGradient,
        ),
      ),
    );
  }
}
