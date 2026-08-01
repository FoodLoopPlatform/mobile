/// Tile-server configuration for every map in the app.
///
/// Swapping providers (or rotating the key) should only ever mean editing this
/// file — no widget code references a tile URL directly.
///
/// The public OSM server (the current fallback) is rate-limited and not
/// permitted for production traffic, so [tileUrlTemplate] switches to MapTiler
/// as soon as [mapTilerKey] is filled in.
abstract class MapConstants {
  /// Get one at https://cloud.maptiler.com → Account → Keys.
  /// Prefer passing it at build time so the key stays out of git:
  ///   flutter run --dart-define=MAPTILER_KEY=your_key
  static const String mapTilerKey = String.fromEnvironment('MAPTILER_KEY');

  static bool get hasMapTilerKey => mapTilerKey.isNotEmpty;

  static String get tileUrlTemplate => hasMapTilerKey
      ? 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapTilerKey'
      : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static String get attribution =>
      hasMapTilerKey ? 'MapTiler · OpenStreetMap' : 'OpenStreetMap contributors';

  /// Sent as the User-Agent — required by the OSM tile usage policy.
  static const String userAgentPackageName = 'com.foodloop.app';

  /// Cairo — initial map center until the user picks a location.
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;
}
