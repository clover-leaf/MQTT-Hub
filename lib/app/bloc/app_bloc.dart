import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._userRepository) : super(const AppState()) {
    on<AppAuthenticatorSubscribed>(_onSubscribed);
    on<AppAuthenticated>(_onAppAuthenticated);
    on<AppUnauthenticated>(_onLogoutRequest);
  }

  final UserRepository _userRepository;

  Future<void> _onSubscribed(
    AppAuthenticatorSubscribed event,
    Emitter<AppState> emit,
  ) async {
    await emit.forEach<bool>(
      _userRepository.authenticatorSubscribe(),
      onData: (isAuthorized) {
        if (isAuthorized) {
          return state.copyWith(status: AppStatus.authenticated);
        } else {
          return state.copyWith(status: AppStatus.unauthenticated);
        }
      },
    );
  }

  Future<void> _onAppAuthenticated(
    AppAuthenticated event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(status: AppStatus.authenticated));
  }

  Future<void> _onLogoutRequest(
    AppUnauthenticated event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(status: AppStatus.unauthenticated));
  }
}
