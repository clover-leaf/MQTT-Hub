import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._userRepository) : super(const AppState()) {
    on<AppAuthenticated>(_onAppAuthenticated);
    on<AppUnauthenticated>(_onAppUnauthenticated);
  }

  final UserRepository _userRepository;

  Future<void> _onAppAuthenticated(
    AppAuthenticated event,
    Emitter<AppState> emit,
  ) async {
    await _userRepository.setToken(event.token, toWrite: event.toWrite);
    if (event.isAdmin) {
      emit(state.copyWith(status: AppStatus.adminAuthenticated));
    } else {
      emit(state.copyWith(status: AppStatus.userAuthenticated));
    }
  }

  Future<void> _onAppUnauthenticated(
    AppUnauthenticated event,
    Emitter<AppState> emit,
  ) async {
    await _userRepository.resetToken();
    await OneSignal.shared.removeExternalUserId();
    emit(state.copyWith(status: AppStatus.unauthenticated));
  }
}
