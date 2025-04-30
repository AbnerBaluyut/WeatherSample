part of 'weather_bloc.dart';

sealed class WeatherEvent {}

class GetWeatherEvent extends WeatherEvent {}
class CancelWeatherEvent extends WeatherEvent {}