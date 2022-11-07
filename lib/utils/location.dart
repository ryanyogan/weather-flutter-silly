import 'dart:async';

import 'package:location/location.dart';

class LocationHelper {
  late double lat;
  late double lng;

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    lat = locationData.latitude!;
    lng = locationData.longitude!;
  }
}

// 2477d8c541973e44e88feb7041af602d
// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric