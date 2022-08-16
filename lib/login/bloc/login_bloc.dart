import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository) : super(const LoginState()) {
    on<LoginSubmitted>(_onLogin);
    on<LoginDomainNameChanged>(_onDomainNameChanged);
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibleChanged>(_onPasswordVisibleChanged);
  }

  final UserRepository _userRepository;

  void _onDomainNameChanged(
    LoginDomainNameChanged event,
    Emitter<LoginState> emit,
  ) {
    final domainName = DomainName.dirty(event.domainName);
    emit(
      state.copyWith(
        domainName: domainName,
        valid: Formz.validate([domainName]).isValid,
      ),
    );
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        valid: Formz.validate([username]).isValid,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        valid: Formz.validate([password]).isValid,
      ),
    );
  }

  void _onPasswordVisibleChanged(
    LoginPasswordVisibleChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(passwordVisible: event.passwordVisible));
  }

  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress || !state.valid) {
        emit(state.copyWith(error: 'Please fill infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final token = await _userRepository.login(
        event.domainName,
        event.username,
        event.password,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess, token: token));
    } catch (error) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          error: error.toString(),
        ),
      );
    }
  }
}
