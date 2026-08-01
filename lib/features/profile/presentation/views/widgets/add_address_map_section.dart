import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/egypt_cities.dart';
import 'package:foodloop/core/utils/map_constants.dart';

const LatLng _defaultCenter = LatLng(
  MapConstants.defaultLatitude,
  MapConstants.defaultLongitude,
);

/// How long the map must sit still before we reverse-geocode the pin. Panning
/// fires continuously, and the platform geocoder throttles aggressively, so we
/// only ask once the user has settled on a spot.
const Duration _geocodeDebounce = Duration(milliseconds: 800);

/// A map pin resolved into whatever address parts the device could name.
/// Any field may be null when the geocoder has nothing for that spot.
class PickedLocation {
  final LatLng position;
  final String? city;
  final String? district;
  final String? street;

  const PickedLocation({
    required this.position,
    this.city,
    this.district,
    this.street,
  });
}

/// Interactive map picker. Opens on the user's current location, keeps a pin
/// fixed in the centre of the viewport, and reports the address under that pin
/// whenever the map settles.
class AddAddressMapSection extends StatefulWidget {
  const AddAddressMapSection({
    super.key,
    required this.onLocationPicked,
    this.initialLocation,
  });

  final ValueChanged<PickedLocation> onLocationPicked;

  /// When set (editing an existing address) the map opens here instead of
  /// hunting for GPS, and the pin is left as-is so the already-filled form
  /// fields aren't overwritten by a geocode the user didn't ask for.
  final LatLng? initialLocation;

  @override
  State<AddAddressMapSection> createState() => _AddAddressMapSectionState();
}

class _AddAddressMapSectionState extends State<AddAddressMapSection> {
  final MapController _mapController = MapController();

  Timer? _debounce;
  bool _isLocating = false;
  bool _isGeocoding = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// flutter_map can fire this while the tree is still building, so the actual
  /// work is deferred a frame — calling setState during build throws.
  void _onMapReady() {
    // Editing: centre on the saved pin and leave the form untouched.
    final existing = widget.initialLocation;
    if (existing != null) {
      _mapController.move(existing, 16);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final position = await _resolveCurrentPosition(silent: true);
      if (!mounted) return;
      final target = position ?? _defaultCenter;
      if (position != null) _mapController.move(target, 16);
      await _reportLocation(target);
    });
  }

  /// setState is unsafe once the screen is popped mid-request.
  void _safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  /// Returns the device's GPS position, or null when unavailable. When [silent]
  /// the failure reasons aren't surfaced — used on first open, where an
  /// unprompted error would be noise.
  Future<LatLng?> _resolveCurrentPosition({bool silent = false}) async {
    _safeSetState(() => _isLocating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!silent) _showMessage(AppStrings.locationServiceDisabled);
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!silent) _showMessage(AppStrings.locationPermissionDenied);
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      if (!silent) _showMessage(AppStrings.locationFetchFailed);
      return null;
    } finally {
      _safeSetState(() => _isLocating = false);
    }
  }

  Future<void> _useMyLocation() async {
    final position = await _resolveCurrentPosition();
    if (position == null) return;
    _mapController.move(position, 16);
    await _reportLocation(position);
  }

  /// Reverse-geocodes [target] and hands the result to the parent form.
  /// The coordinates are always reported, even if naming them fails.
  Future<void> _reportLocation(LatLng target) async {
    _safeSetState(() => _isGeocoding = true);

    // Geocoding is best-effort — on any failure the pin itself is still valid,
    // so we fall back to reporting bare coordinates.
    var picked = PickedLocation(position: target);
    try {
      await setLocaleIdentifier('ar');
      final places = await placemarkFromCoordinates(
        target.latitude,
        target.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;
        picked = PickedLocation(
          position: target,
          city: EgyptCities.matchFrom(place.administrativeArea) ??
              EgyptCities.matchFrom(place.locality),
          district: _firstNonEmpty([place.subLocality, place.locality]),
          street: _firstNonEmpty([place.street, place.thoroughfare]),
        );
      }
    } catch (_) {
      // Keep the coordinates-only fallback.
    }

    if (!mounted) return;
    _safeSetState(() => _isGeocoding = false);
    widget.onLocationPicked(picked);
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    _debounce?.cancel();
    _debounce = Timer(_geocodeDebounce, () => _reportLocation(camera.center));
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.initialLocation ?? _defaultCenter,
                    initialZoom: widget.initialLocation != null ? 16 : 13,
                    onMapReady: _onMapReady,
                    onPositionChanged: _onPositionChanged,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: MapConstants.tileUrlTemplate,
                      userAgentPackageName: MapConstants.userAgentPackageName,
                    ),
                    SimpleAttributionWidget(
                      alignment: Alignment.bottomLeft,
                      backgroundColor: AppColors.surface.withValues(alpha: 0.7),
                      source: Text(MapConstants.attribution),
                    ),
                  ],
                ),

                // --- Fixed centre pin ---
                IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 32.r),
                      child: Icon(
                        Icons.location_on,
                        size: 44.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                // --- Resolving badge ---
                if (_isGeocoding || _isLocating)
                  Positioned(
                    top: 12.r,
                    left: 12.r,
                    child: _StatusBadge(
                      label: _isLocating
                          ? AppStrings.locatingYou
                          : AppStrings.resolvingAddress,
                    ),
                  ),

                // --- My-location action ---
                Positioned(
                  bottom: 12.r,
                  right: 12.r,
                  child: Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _isLocating ? null : _useMyLocation,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: _isLocating
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.my_location_rounded,
                                size: 20.r,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Row(
          children: [
            Icon(Icons.info_outline_rounded,
                size: 18.r, color: AppColors.primaryLight),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                AppStrings.mapDragHint,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.r,
            height: 12.r,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
