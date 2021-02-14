class Coordinates {
  Coordinates({
    this.longitude,
    this.latitude,
    this.altitude,
  });

  /// The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  final double longitude;

  /// The altitude of the in meters.
  final double altitude;
}
