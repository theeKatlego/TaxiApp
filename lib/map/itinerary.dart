import 'package:TaxiApp/bloc/place-bloc.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/search.dart';

class Itinerary extends StatefulWidget {
  @override
  _ItineraryState createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Itinerary'),
        backgroundColor: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.3),
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
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      hintText: 'Your location',
                      prefixIcon: Icon(Icons.my_location,
                          size: 17, color: Colors.black),
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
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      hintText: 'Set your destination',
                      prefixIcon:
                          Icon(Icons.place, size: 17, color: Colors.black),
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
                      buttonColor: Theme.of(context).accentColor,
                      child: RaisedButton(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).accentIconTheme.color,
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
                        leading: Icon(Icons.place,
                            color: Theme.of(context).colorScheme.onPrimary),
                        title: Text(places[i].title),
                        subtitle: Text(places[i].address.addressText),
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
