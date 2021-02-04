import 'dart:math';

import 'package:TaxiApp/bloc/place-bloc.dart';
import 'package:TaxiApp/models/place.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

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
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
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
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      hintText: 'Esse e seu local',
                      prefixIcon: Icon(
                        Icons.my_location,
                        size: 17,
                      ),
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextField(
//                  autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      hintText: 'Para onde?',
                      prefixIcon: Icon(Icons.place, size: 17),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _getPlaces),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    ButtonTheme(
                      minWidth: 60,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: RaisedButton(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
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
              })
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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _globalKey,
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

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 8000;
      hereMapController.camera.lookAtPointWithDistance(
          GeoCoordinates(52.530932, 13.384915), distanceToEarthInMeters);
    });
  }
}
/** Map ends here **/
