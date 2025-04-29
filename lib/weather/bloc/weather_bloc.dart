import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_weather/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  final WeatherUseCase weatherUseCase;

  WeatherBloc() : 
  weatherUseCase = injector(),
  super(WeatherInitial()) {
    on<GetWeatherEvent>(_getWeather);
  }

  _getWeather(GetWeatherEvent event, Emitter<WeatherState> emit) async {

    emit(WeatherLoading());
    final result = await weatherUseCase.execute(latitude: 16.4023, longitude: 120.5960).run();
    result.fold((err) {
      emit(WeatherFailure());
    }, (data) {
       emit(WeatherSuccess(data));
    });
  }
}