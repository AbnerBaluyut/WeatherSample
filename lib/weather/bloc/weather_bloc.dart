import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_weather/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  final WeatherService _weatherService;

  WeatherBloc() : 
  _weatherService = WeatherService(),
  super(WeatherInitialState()) {
    on<GetWeatherEvent>(_getWeather);
    on<CancelWeatherEvent>(_cancel);    
  }

  _getWeather(GetWeatherEvent event, Emitter<WeatherState> emit) async {

    emit(WeatherLoadingState());

    final location = await _weatherService.getCurrentLocation();

    switch (location.status) {
      case LocationStatus.success:   
        double lat = location.position?.latitude ?? 0.0;
        double lng = location.position?.longitude ?? 0.0;
        final result = await _weatherService.getWeather(latitude: lat, longitude: lng).run();
        result.fold((err) {
          emit(WeatherFailureState(err));
        }, (data) {
          emit(WeatherSuccessState(data));
        });
        break;
      case LocationStatus.serviceDisabled:
        emit(WeatherFailureState("service_disabled"));
        break;
      case LocationStatus.permissionDenied:
        emit(WeatherFailureState("permission_denied"));
        break;
      case LocationStatus.permissionDeniedForever:
        emit(WeatherFailureState("permission_denied_forever"));
        break;
      case LocationStatus.error:
        emit(WeatherFailureState("Something went wrong. Please try again"));
        break;
    }
  }

  _cancel(CancelWeatherEvent event, Emitter<WeatherState> emit) {
    _weatherService.cancel();
    emit(CancelWeatherState());
  } 
}