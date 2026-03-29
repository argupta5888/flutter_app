import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(const LocationState()) {
    on<LocationFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
      LocationFetchRequested event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
      userLat: 19.0596,
      userLng: 72.8295,
      userAddress: 'Bandra West, Mumbai',
      isLoading: false,
    ));
  }
}
