import 'package:flutter/material.dart';
import 'package:get_weather/get_weather.dart';

class WeatherStatus extends StatelessWidget {

  const WeatherStatus({super.key, required this.data});

  final WeatherEntity? data;

  @override
  Widget build(BuildContext context) {

    IconData icon;

    switch (data?.condition) {
      case WeatherCondition.clear:
        icon = Icons.wb_sunny;
      case WeatherCondition.cloudy:
        icon = Icons.cloud;
      case WeatherCondition.foggy:
        icon = Icons.blur_on;
      case WeatherCondition.rainy:
        icon = Icons.umbrella;
      case WeatherCondition.snowy:
        icon = Icons.ac_unit;
      case WeatherCondition.thunderstorm:
        icon = Icons.flash_on;
      default:
        icon = Icons.help_outline;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 80,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 16),
        if (data != null) Text(
          "${data?.label} ${data?.temperature.toStringAsFixed(1)}°C",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}