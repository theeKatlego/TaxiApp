import 'dart:developer';

import 'package:TaxiApp/bloc/place-bloc.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/search.dart';
import 'package:TaxiApp/map/select-location.dart';
import 'call-taxi.dart';

class Itinerary extends StatefulWidget {
  Place destination;
  Place departure;

  Itinerary({@required this.departure, @required this.destination, Key key})
      : super(key: key);

  @override
  _ItineraryState createState() =>
      _ItineraryState(departure: departure, destination: destination);
}

class _ItineraryState extends State<Itinerary> {
  BuildContext _context;
  PlaceBloc _placeBloc;
  FocusNode destinationTextFieldFocusNode = FocusNode();
  FocusNode departureTextFieldFocusNode = FocusNode();
  TextEditingController destinationTextFieldController =
      TextEditingController();
  TextEditingController departureTextFieldController = TextEditingController();
  bool settingDestination = false;
  bool settingDeparture = false;

  Place currentLocation;
  Place departure;
  Place destination;

  _ItineraryState({@required this.departure, @required this.destination});

  @override
  void initState() {
    super.initState();
    setLocationAsDepature(departure);
    setLocationAsDestination(destination);

    _placeBloc = PlaceBloc();
    destinationTextFieldFocusNode.addListener(destinationTextFieldFocusChanged);
    departureTextFieldFocusNode.addListener(departureTextFieldFocusChanged);
    PlaceBloc().getAddressForCurrentCoordinates((Place address) {
      setState(() {
        currentLocation = address;
      });

      if (departure == null) setLocationAsDepature(currentLocation);
    });
  }

  @override
  void dispose() {
    _placeBloc.dispose();
    destinationTextFieldFocusNode.dispose();
    departureTextFieldFocusNode.dispose();
    super.dispose();
  }

  setLocationAsDepature(Place location) {
    setState(() {
      departure = location;
      departureTextFieldController.value = TextEditingValue(
        text: departure?.title,
        composing: TextRange.empty,
      );
    });
  }

  setLocationAsDestination(Place location) {
    setState(() {
      destination = location;
      destinationTextFieldController.value = TextEditingValue(
        text: destination.title,
        composing: TextRange.empty,
      );
    });
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

  @override
  Widget build(BuildContext context) {
    _context = context;

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
                  controller: departureTextFieldController,
                  focusNode: departureTextFieldFocusNode,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Color(0XFFababab))),
                      hintText: 'Set pickup location',
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
                SizedBox(height: 10),
                TextField(
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
                    onChanged: _getPlaces),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: settingDeparture || settingDestination
                          ? ButtonTheme(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              buttonColor: Theme.of(context).accentColor,
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SelectLocation(settingDeparture
                                                ? _onDepartureSelected
                                                : _onDestinationSelected))),
                                icon: Icon(Icons.map_outlined),
                                label: Text("Set location on map"),
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(width: 110),
                    if (destination != null && departure != null)
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
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CallTaxi(departure, destination))),
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
                if (snap.data == null || !settingDestination) {
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
                          settingDestination = false;
                          setLocationAsDestination(places[i]);
                          destinationTextFieldFocusNode.unfocus();
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
