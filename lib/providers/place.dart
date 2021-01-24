import 'dart:convert';
import 'dart:math';
import 'package:TaxiApp/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

Future<List<Place>> getLocation(txt) async {
  var rng = new Random();
  final String random = rng.nextInt(9999999).toString();
  final String URL =
      "https://maps.googleapis.com/maps/api/place/textsearch/json?input=${txt}&key=AIzaSyCvUwKgL_rEuLlMKL5RxPOZjSIn6yr5pQA&language=pt-BR&sessiontoken=${random}";
  print('URL ${URL}');
  var response = await http
      .get(Uri.encodeFull(URL), headers: {"Accept": "application/json"});
  print(response.body);

  return Place.fromJson(json.decode(response.body));
}
