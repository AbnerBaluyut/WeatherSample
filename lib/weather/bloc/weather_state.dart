part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherFailure extends WeatherState {
  final String errorMessage;
  const WeatherFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class WeatherSuccess extends WeatherState {

  final WeatherEntity weather;

  const WeatherSuccess(this.weather);

  @override
  List<Object?> get props => [weather];
}