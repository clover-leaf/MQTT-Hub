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
    on<LoginEmailChanged>(_onEmailChanged);
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

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        valid: Formz.validate([email]).isValid,
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
