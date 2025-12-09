import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';  // <-- REQUIRED



class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String _currentAddress = "Detecting location...";
  bool _isLoading = false;

  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;

  // ✅ Fetch location with proper error handling
  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentAddress = "Location services disabled";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentAddress = "Location permission denied";
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentAddress = "Location permission permanently denied";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      if (_currentPosition != null) {
        _currentAddress = await _getAddressFromLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }

      print("✅ Location fetched: $_currentAddress");
    } catch (e) {
      print("❌ Location Error: $e");
      _currentAddress = "Location unavailable";
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Reverse Geocoding
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '';

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += '${place.subLocality}, ';
        } else if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          address += '${place.thoroughfare}, ';
        }

        if (place.locality != null && place.locality!.isNotEmpty) {
          address += place.locality!;
        }

        return address.isNotEmpty ? address : "Lucknow, UP";
      }
    } catch (e) {
      print("❌ Geocoding Error: $e");
    }

    return "Location detected";
  }

  // ✅ Retry fetching location
  Future<void> retryFetchLocation() async {
    await fetchLocation();
  }
}