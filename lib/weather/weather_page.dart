import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_weather/get_weather.dart';
import 'bloc/weather_bloc.dart';

class WeatherPageWrapper extends StatelessWidget {
  const WeatherPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WeatherBloc()..add(GetWeatherEvent()),
      child: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  WeatherEntity? _weather;
  Timer? _timer;

  void _startWeatherUpdates() {

    setState(() {
      _timer = Timer.periodic(Duration(seconds: 10), (_) => context.read<WeatherBloc>().add(GetWeatherEvent()));
    });
  }

  void _cancelTimer() {
    setState(() {
      _timer?.cancel();
      _timer = null;
    });
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (ctx, state) {

        if (state is WeatherSuccess) {
          _weather = state.weather;
        }

        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                spacing: 10.0,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(child: _buildWeather(_weather)),
                  ElevatedButton(onPressed: _timer != null ? null : _startWeatherUpdates, child: Text("Start Real Time")),
                  ElevatedButton(onPressed: _timer == null ? null : _cancelTimer, child: Text("Cancel Real Time"))
                ],
              ),
              if (state is WeatherLoading) CircularProgressIndicator()
            ],
          ),
        );
      }
    );
  }

  Widget _buildWeather(WeatherEntity? data) {

    IconData icon;

    switch (data?.condition) {
      case WeatherConditionEnum.clear:
        icon = Icons.wb_sunny;
      case WeatherConditionEnum.cloudy:
        icon = Icons.cloud;
      case WeatherConditionEnum.foggy:
        icon = Icons.blur_on;
      case WeatherConditionEnum.rainy:
        icon = Icons.umbrella;
      case WeatherConditionEnum.snowy:
        icon = Icons.ac_unit;
      case WeatherConditionEnum.thunderstorm:
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
        Text(
          "${data?.label ?? ""} ${data?.temperature.toStringAsFixed(1)}°C",
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