import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    if (event.email == 'demo@foodrush.com' &&
        event.password == 'password123') {
      emit(AuthAuthenticated(User(
        id: 'u001',
        name: 'Rahul Sharma',
        email: event.email,
        phone: '+91 98765 43210',
        address: 'Bandra West, Mumbai, 400050',
      )));
    } else {
      emit(const AuthFailure(
          'Invalid email or password. Use demo@foodrush.com / password123'));
    }
  }

  void _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}
