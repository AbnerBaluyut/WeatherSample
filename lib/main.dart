import 'package:flutter/material.dart';
import 'package:get_weather/get_weather.dart';

import 'app.dart';

void main() async {
  WeatherService.initialize();
  runApp(const App());
}