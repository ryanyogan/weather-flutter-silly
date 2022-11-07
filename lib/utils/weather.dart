import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:weather/utils/location.dart';

const apiKey = "2477d8c541973e44e88feb7041af602d";

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({required this.weatherIcon, required this.weatherImage});
}

class WeatherData {
  WeatherData({required this.locationData});

  LocationHelper locationData;
  double currentTemp = 0.0;
  int currentCondition = 0;

  Future<void> getCurrentTemperature() async {
    var url = Uri.https(
      "api.openweathermap.org",
      "data/2.5/weather",
      {
        "lat": locationData.lat.toString(),
        "lon": locationData.lng.toString(),
        "units": "imperial",
        "appid": apiKey
      },
    );
    print(url);
    Response response = await get(url);
    print(response.body);

    if (response.statusCode == 200) {
      String data = response.body;

      var currentWeather = jsonDecode(data);

      try {
        currentTemp = currentWeather["main"]["temp"];
        currentCondition = currentWeather["weather"][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print("Could not fetch temp");
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
          weatherIcon: const Icon(FontAwesomeIcons.cloud),
          weatherImage: const AssetImage('assets/cloudy.png'));
    } else {
      var now = DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
            weatherIcon: const Icon(FontAwesomeIcons.moon,
                size: 75.0, color: Colors.white),
            weatherImage: const AssetImage('assets/night.png'));
      } else {
        return WeatherDisplayData(
            weatherIcon: const Icon(FontAwesomeIcons.sun,
                size: 75.0, color: Colors.white),
            weatherImage: const AssetImage('assets/sunny.png'));
      }
    }
  }
}
