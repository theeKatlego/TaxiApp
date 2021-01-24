import 'dart:math';

import 'package:TaxiApp/bloc/place-bloc.dart';
import 'package:TaxiApp/models/place.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../counter_bloc.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      bloc.updateCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taxi App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              // Wrap our widget with a StreamBuilder
              stream: bloc.getCount, // pass our Stream getter here
              initialData: 0, // provide an initial data
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data}');
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Text('No Posts');
                }
              }, // access the data in our Stream here
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CounterProvider {
  int count = 0;
  void increaseCount() => count++;
}

/** Address starts here **/

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  PlaceBloc _placeBloc;

  @override
  void initState() {
    _placeBloc = PlaceBloc();
    super.initState();
  }

  @override
  void dispose() {
    _placeBloc.dispose();
    super.dispose();
  }

  _getPlaces(txt) {
    _placeBloc.searchPlace(txt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Locais de partida'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0.0, 10.0),
                  blurRadius: 10.0,
                ),
              ],
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: Color(0XFFababab))
                      ),
                      hintText: 'Esse e seu local',
                      prefixIcon: Icon(Icons.my_location,size: 17,),
                      border: OutlineInputBorder()

                  ),

                ),
                SizedBox(height: 10),
                TextField(
//                  autofocus: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: Color(0XFFababab))
                      ),
                      hintText: 'Para onde?',
                      prefixIcon: Icon(Icons.place, size: 17),
                      border: OutlineInputBorder(),
                  ),
                  onChanged: _getPlaces
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(child: Container(),),
                    ButtonTheme(
                      minWidth: 60,
                      height: 60,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: RaisedButton(
                          child: Icon(Icons.arrow_forward, color: Colors.white,),
                          onPressed:() {},

                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          StreamBuilder(
            stream: _placeBloc.placeStream(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              List<Place> places = snap.data;
              if (snap.data == null) {
                return Container();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (BuildContext c, int i) {
                    return ListTile(
                      leading: Icon(Icons.place),
                      title: Text(places[i].name),
                      subtitle: Text(places[i].address),
                      onTap: () {
                        print('luan');
                      },
                    );
                  },
                ),
              );
            }
          )


        ],
      ),
    );
  }
}

/** Address end here **/


/** Map starts here **/

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  BitmapDescriptor _markerIcon;
  GoogleMapController controller;
  Set<Marker> markers = <Marker>[].toSet();

  double rotate01 = 0;
  double rotate02 = 0;

  Position position;
  LatLng location = LatLng(-8.994199, -40.271823);
  CameraPosition cameraPosition =
      new CameraPosition(target: LatLng(-8.997233, -40.272655), zoom: 5);

  @override
  void initState() {
    getLocation().then((res) {
      configureMarkers();
    });

    super.initState();
  }

  configureMarkers() {
    var rd = Random();
    double lat = position.latitude;
    double lng = position.longitude;
    setState(() {});

    markers.add(
        Marker(
          markerId: MarkerId("marker_1"),
          position: LatLng(lat - (rd.nextInt(399) * 0.00001), lng +(rd.nextInt(399) * 0.00001)),
          icon: _markerIcon,
          rotation: rotate01),
    );
    markers.add(
      Marker(
          markerId: MarkerId("marker_2"),
          position: LatLng(lat + (rd.nextInt(399) * 0.00001), lng -(rd.nextInt(399) * 0.00001)),
          icon: _markerIcon,
          rotation: (rd.nextInt(380) * 1.0)),
    );

    markers.add(
      Marker(
          markerId: MarkerId("marker_3"),
          position: LatLng(lat + (rd.nextInt(399) * 0.00001), lng +(rd.nextInt(399) * 0.00001)),
          icon: _markerIcon,
          rotation: (rd.nextInt(380) * 1.0)),
    );

    markers.add(
      Marker(
          markerId: MarkerId("marker_4"),
          position: LatLng(lat - (rd.nextInt(399) * 0.00001), lng +(rd.nextInt(399) * 0.00001)),
          icon: _markerIcon,
          rotation: rotate02),
    );


    var future = new Future.delayed(const Duration(milliseconds: 3500), (){
//      int i = rd.nextInt(4);
      setState(() {
        print('rotacao');
        rotate01 = (rd.nextInt(380) * 1.0);
        rotate02 = (rd.nextInt(380) * 1.0);
      });
    });
//
//    var timer = Timer.periodic(new Duration(milliseconds: 200), (timer) {
//      if(lat < -8.997258999999975) {
//        timer.cancel();
//      }
//      setState((){
//        lng2 -= 0.00003;
//        lat = lat - 0.00002;
//        _localCar2  = new LatLng(lat2, lng2);
//        _localCar   = new LatLng(lat, lng);
//      });
//    });
  }

  Future<void> getLocation() async {
    position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16.5)));
    print(position.latitude);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    _createMarkerImageFromAsset(context);

    return Scaffold(
        key: _globalKey,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              onMapCreated: _onMapCreated,
              markers: markers,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: false,
              zoomGesturesEnabled: true,
            ),
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
                              width: 10,
                              height: 10,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Para onde?'),
                          SizedBox(width: width * 0.5),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 450),
                                pageBuilder: (context, _, __) =>
                                    AddressPage()));
                      }),
                ))
          ],
        ));
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/icon_car_top.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }
}
/** Map ends here **/