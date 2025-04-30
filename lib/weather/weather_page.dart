import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_weather/get_weather.dart';
import 'bloc/weather_bloc.dart';
import 'components/weather_status.dart';

class WeatherPageWrapper extends StatelessWidget {
  const WeatherPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WeatherBloc(),
      child: _WeatherPage(),
    );
  }
}

class _WeatherPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<_WeatherPage> {

  WeatherEntity? _weather;
  Timer? _timer;

  void _startWeatherUpdates() {

    if (_timer == null) {
      context.read<WeatherBloc>().add(GetWeatherEvent());
    }

    _setTimer();
  }

  void _setTimer() {

    setState(() {
      _timer = Timer.periodic(Duration(seconds: 10), (_) => context.read<WeatherBloc>().add(GetWeatherEvent()));
    });
  }

  void _cancelTimer() {
    context.read<WeatherBloc>().add(CancelWeatherEvent());
    setState(() {
      _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _cancelTimer();
    _timer = null;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherFailureState) {
          log("Error: ${state.errorMessage}");
        }
      },
      builder: (ctx, state) {

        if (state is WeatherSuccessState) {
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
                  Center(child: WeatherStatus(data: _weather)),
                  ElevatedButton(onPressed: _timer != null ? null : _startWeatherUpdates, child: Text("Start Real Time")),
                  ElevatedButton(onPressed: _timer == null ? null : _cancelTimer, child: Text("Cancel Real Time"))
                ],
              ),
              if (state is WeatherLoadingState) CircularProgressIndicator()
            ],
          ),
        );
      }
    );
  }
}