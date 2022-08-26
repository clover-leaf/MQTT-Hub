import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository) : super(const LoginState()) {
    on<LoginSubmitted>(_onLogin);
    on<LoginDomainNameChanged>(_onDomainNameChanged);
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
  }

  final UserRepository _userRepository;

  void _onDomainNameChanged(
    LoginDomainNameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(domainName: event.domainName));
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginStatus.processing));
      final res = await _userRepository.login(
        state.domainName,
        state.username,
        state.password,
      );
      final token = res['token'] as String;
      final isAdmin = res['isAdmin'] as bool;
      emit(
        state.copyWith(
          status: LoginStatus.success,
          token: token,
          isAdmin: isAdmin,
        ),
      );
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: LoginStatus.failure, error: () => err));
      emit(state.copyWith(status: LoginStatus.normal, error: () => null));
    }
  }
}
