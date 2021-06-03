import 'package:TaxiApp/bloc/place-bloc.dart';
import 'package:TaxiApp/components/sideMenu.dart';
import 'package:TaxiApp/map/call-taxi.dart';
import 'package:TaxiApp/map/mapController.dart';
import 'package:TaxiApp/models/User.dart';
import 'package:TaxiApp/services/AuthService.dart';
import 'package:TaxiApp/style/theme.dart' as namelaTheme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BuildContext _context;
  PlaceBloc _placeBloc;
  Place currentLocation;
  Place departure;
  Place destination;

  bool settingDestination = false;
  bool settingDeparture = false;

  FocusNode destinationTextFieldFocusNode = FocusNode();
  FocusNode departureTextFieldFocusNode = FocusNode();
  TextEditingController destinationTextFieldController =
      TextEditingController();
  TextEditingController departureTextFieldController = TextEditingController();

  MapController _HereMapController;

  @override
  void initState() {
    super.initState();
    PlaceBloc().getAddressForCurrentCoordinates((Place currentLocationAddress) {
      setState(() {
        currentLocation = currentLocationAddress;
        setLocationAsDepature(currentLocation);
      });
    });
    _placeBloc = PlaceBloc();
    destinationTextFieldFocusNode.addListener(destinationTextFieldFocusChanged);
    departureTextFieldFocusNode.addListener(departureTextFieldFocusChanged);
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
              child: SizedBox(
                width: width * 0.9,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: departureTextFieldController,
                    focusNode: departureTextFieldFocusNode,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5, color: Color(0XFFababab))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5, color: Color(0XFFababab))),
                        hintText: 'Set pickup location',
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear,
                              color: Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {
                            setState(() {
                              departure = null;
                              departureTextFieldController.value =
                                  TextEditingValue(
                                text: "",
                                composing: TextRange.empty,
                              );
                            });
                          },
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.my_location,
                              color: Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {
                            setState(() {
                              setLocationAsDepature(currentLocation);
                            });
                          },
                        ),
                        border: OutlineInputBorder()),
                  ),
                ),
              )),
          Positioned(
              top: height * 0.20,
              left: 20,
              child: SizedBox(
                width: width * 0.9,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: destinationTextFieldController,
                    focusNode: destinationTextFieldFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      hintText: 'Set your destination',
                      fillColor: Colors.black,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,
                            color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () {
                          setState(() {
                            destination = null;
                            destinationTextFieldController.value =
                                TextEditingValue(
                              text: "",
                              composing: TextRange.empty,
                            );
                          });
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.place,
                            color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(),
                    ),
                    /*onChanged: _getPlaces*/
                  ),
                ),
              ))
        ],
      ),
      floatingActionButton: destination != null && departure != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 450),
                        pageBuilder: (context, _, __) =>
                            CallTaxi(departure, destination)));
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
        /*_HereMapController = */ MapController(_context, hereMapController,
            (GeoCoordinates coordinates) => _locationSelected(coordinates));
        setState(() {
          // _HereMapController = MapController(_context, hereMapController, (GeoCoordinates coordinates) => _locationSelected(coordinates));
        });
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  void _locationSelected(GeoCoordinates coordinates) {
    PlaceBloc().getAddressForCoordinates(coordinates, (Place place) async {
      if (settingDeparture) await setLocationAsDepature(place);
      if (settingDestination) await setLocationAsDestination(place);
    });
  }

  @override
  void dispose() {
    _placeBloc.dispose();
    destinationTextFieldFocusNode.dispose();
    departureTextFieldFocusNode.dispose();
    super.dispose();
  }

  setLocationAsDepature(Place location) async {
    setState(() {
      departure = location;
      departureTextFieldController.value = TextEditingValue(
        text: departure?.title ?? '',
        composing: TextRange.empty,
      );
    });
    await _HereMapController.showAnchoredMapMarkers(location.geoCoordinates);
  }

  setLocationAsDestination(Place location) async {
    setState(() {
      destination = location;
      destinationTextFieldController.value = TextEditingValue(
        text: destination?.title ?? '...',
        composing: TextRange.empty,
      );
    });
    await _HereMapController.showSelectedLocationMapMarkers(
        location.geoCoordinates);
  }

  _getPlaces(text) {
    if (text != null && text.trim() != "") _placeBloc.searchPlace(text);
  }

  destinationTextFieldFocusChanged() {
    setState(() {
      if (destinationTextFieldFocusNode.hasFocus) {
        settingDestination = true;
      } else {
        settingDestination = false;
      }
    });
  }

  departureTextFieldFocusChanged() {
    setState(() {
      if (departureTextFieldFocusNode.hasFocus) {
        settingDeparture = true;
      } else {
        settingDeparture = false;
      }
    });
  }

  _onDepartureSelected(Place selectedLocation) {
    if (destination == null)
      Navigator.of(context).pop([selectedLocation, destination]);
    else
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                CallTaxi(selectedLocation, destination),
            fullscreenDialog: true,
          ));
  }

  _onDestinationSelected(Place selectedLocation) {
    if (departure == null)
      Navigator.of(context).pop([departure, selectedLocation]);
    else
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                CallTaxi(departure, selectedLocation),
            fullscreenDialog: true,
          ));
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
  AuthService _authService;
  User user;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _authService.currentUser().then((value) => setState(() {
          user = value;
        }));
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
          onPressed: () async {},
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
                child: (user?.photoUrl != null && user?.photoUrl?.trim() != "")
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(user.photoUrl),
                      )
                    : CircleAvatar(
                        radius: 100,
                        child: user?.displayName != null &&
                                user.displayName.length > 0
                            ? Text(
                                user.displayName[0],
                                style: TextStyle(fontSize: 90),
                              )
                            : Icon(Icons.person_rounded)),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                user?.displayName ?? "John Snow",
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
