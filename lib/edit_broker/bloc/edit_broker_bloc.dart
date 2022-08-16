import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_broker_event.dart';
part 'edit_broker_state.dart';

class EditBrokerBloc extends Bloc<EditBrokerEvent, EditBrokerState> {
  EditBrokerBloc(
    this._userRepository, {
    required Project project,
    required Broker? initBroker,
  }) : super(
          EditBrokerState(
            project: project,
            initBroker: initBroker,
            brokerName: initBroker != null
                ? BrokerName.dirty(initBroker.name)
                : const BrokerName.pure(),
            urlName: initBroker != null
                ? UrlName.dirty(initBroker.url)
                : const UrlName.pure(),
            brokerAccount: initBroker != null && initBroker.account != null
                ? BrokerAccount.dirty(initBroker.account!)
                : const BrokerAccount.pure(),
            brokerPassword: initBroker != null && initBroker.password != null
                ? BrokerPassword.dirty(initBroker.password!)
                : const BrokerPassword.pure(),
          ),
        ) {
    on<EditSubmitted>(_onSubmitted);
    on<EditBrokerNameChanged>(_onBrokerNameChanged);
    on<EditUrlNameChanged>(_onBrokerUrlChanged);
    on<EditBrokerAccountChanged>(_onBrokerAccountChanged);
    on<EditBrokerPasswordChanged>(_onBrokerPasswordChanged);
  }

  final UserRepository _userRepository;

  void _onBrokerNameChanged(
    EditBrokerNameChanged event,
    Emitter<EditBrokerState> emit,
  ) {
    final brokerName = BrokerName.dirty(event.brokerName);
    emit(
      state.copyWith(
        brokerName: brokerName,
        valid: Formz.validate([brokerName]).isValid,
      ),
    );
  }

  void _onBrokerUrlChanged(
    EditUrlNameChanged event,
    Emitter<EditBrokerState> emit,
  ) {
    final urlName = UrlName.dirty(event.urlName);
    emit(
      state.copyWith(
        urlName: urlName,
        valid: Formz.validate([urlName]).isValid,
      ),
    );
  }

  void _onBrokerAccountChanged(
    EditBrokerAccountChanged event,
    Emitter<EditBrokerState> emit,
  ) {
    final brokerAccount = BrokerAccount.dirty(event.brokerAccount);
    emit(
      state.copyWith(
        brokerAccount: brokerAccount,
        valid: Formz.validate([brokerAccount]).isValid,
      ),
    );
  }

  void _onBrokerPasswordChanged(
    EditBrokerPasswordChanged event,
    Emitter<EditBrokerState> emit,
  ) {
    final brokerPassword = BrokerPassword.dirty(event.brokerPassword);
    emit(
      state.copyWith(
        brokerPassword: brokerPassword,
        valid: Formz.validate([brokerPassword]).isValid,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSubmitted event,
    Emitter<EditBrokerState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress || !state.valid) {
        emit(state.copyWith(error: 'Please fill infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final broker = state.initBroker?.copyWith(
            name: event.brokerName,
            url: event.urlName,
            account: event.brokerAccount,
            password: event.brokerPassword,
          ) ??
          Broker(
            projectID: state.project.id,
            name: event.brokerName,
            url: event.urlName,
            account: event.brokerAccount,
            password: event.brokerPassword,
          );
      await _userRepository.saveBroker(broker);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
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
