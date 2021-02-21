import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

Future<Uint8List> loadFileAsUint8List(String fileName) async {
  // The path refers to the assets directory as specified in pubspec.yaml.
  ByteData fileData = await rootBundle.load('assets/images/' + fileName);
  return Uint8List.view(fileData.buffer);
}
