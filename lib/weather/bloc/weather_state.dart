part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherFailureState extends WeatherState {
  final String errorMessage;
  const WeatherFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class WeatherSuccessState extends WeatherState {

  final WeatherEntity weather;

  const WeatherSuccessState(this.weather);

  @override
  List<Object?> get props => [weather];
}

class CancelWeatherState extends WeatherState {}