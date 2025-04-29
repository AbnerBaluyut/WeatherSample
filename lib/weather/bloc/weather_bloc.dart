import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_weather/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  final WeatherUseCase weatherUseCase;
  
  final LocationManager _locationManager = LocationManager();

  WeatherBloc() : 
  weatherUseCase = injector(),
  super(WeatherInitial()) {
    on<GetWeatherEvent>(_getWeather);
  }

  _getWeather(GetWeatherEvent event, Emitter<WeatherState> emit) async {

    emit(WeatherLoading());

    final location = await _locationManager.getCurrentLocation();

    switch (location.status) {
      case LocationStatus.success:   
        double lat = location.position?.latitude ?? 0.0;
        double lng = location.position?.longitude ?? 0.0;
        final result = await weatherUseCase.execute(latitude: lat, longitude: lng).run();
        result.fold((err) {
          emit(WeatherFailure(err));
        }, (data) {
          emit(WeatherSuccess(data));
        });
        break;
      case LocationStatus.serviceDisabled:
        emit(WeatherFailure("service_disabled"));
        break;
      case LocationStatus.permissionDenied:
        emit(WeatherFailure("permission_denied"));
        break;
      case LocationStatus.permissionDeniedForever:
        emit(WeatherFailure("permission_denied_forever"));
        break;
      case LocationStatus.error:
        emit(WeatherFailure("Something went wrong. Please try again"));
        break;
    }
  }
}