import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_broker_event.dart';
part 'edit_broker_state.dart';

class EditBrokerBloc extends Bloc<EditBrokerEvent, EditBrokerState> {
  EditBrokerBloc(
    this._userRepository, {
    required Project parentProject,
    required Broker? initialBroker,
    required bool isAdmin,
    required bool isEdit,
  }) : super(
          EditBrokerState(
            isEdit: isEdit,
            isAdmin: isAdmin,
            parentProject: parentProject,
            initialBroker: initialBroker,
            name: initialBroker?.name ?? '',
            url: initialBroker?.url ?? '',
            port: initialBroker?.port.toString() ?? '',
            account: initialBroker?.account ?? '',
            password: initialBroker?.password ?? '',
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<IsEditChanged>(_onIsEditChanged);
    on<NameChanged>(_onNameChanged);
    on<UrlChanged>(_onUrlChanged);
    on<PortChanged>(_onPortChanged);
    on<AccountChanged>(_onAccountChanged);
    on<PasswordChanged>(_onPasswordChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<EditBrokerState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<EditBrokerState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onUrlChanged(UrlChanged event, Emitter<EditBrokerState> emit) {
    emit(state.copyWith(url: event.url));
  }

  void _onPortChanged(PortChanged event, Emitter<EditBrokerState> emit) {
    emit(state.copyWith(port: event.port));
  }

  void _onAccountChanged(AccountChanged event, Emitter<EditBrokerState> emit) {
    emit(state.copyWith(account: event.account));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<EditBrokerState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditBrokerState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditBrokerStatus.processing));
      final broker = state.initialBroker?.copyWith(
            projectID: state.parentProject.id,
            name: state.name,
            url: state.url,
            port: int.parse(state.port),
            account: state.account,
            password: state.password,
          ) ??
          Broker(
            projectID: state.parentProject.id,
            name: state.name,
            url: state.url,
            port: int.parse(state.port),
            account: state.account,
            password: state.password,
          );
      await _userRepository.saveBroker(broker);
      emit(state.copyWith(status: EditBrokerStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditBrokerStatus.failure, error: () => err));
      emit(state.copyWith(status: EditBrokerStatus.normal, error: () => null));
    }
  }
}
