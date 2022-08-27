import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_alert_event.dart';
part 'edit_alert_state.dart';

class EditAlertBloc extends Bloc<EditAlertEvent, EditAlertState> {
  EditAlertBloc(
    this._userRepository, {
    required String initialID,
    required List<Device> devices,
    required List<Attribute> attributes,
    required List<Condition> initialConditions,
    required List<TAction> initialActions,
    required Alert? initialAlert,
  }) : super(
          EditAlertState(
            id: initialID,
            devices: devices,
            attributes: attributes,
            initialConditions: initialConditions,
            conditions: initialConditions,
            initialActions: initialActions,
            actions: initialActions,
            name: initialAlert?.name ?? '',
            selectedDeviceID: initialAlert?.deviceID,
            initialAlert: initialAlert,
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<SelectedDeviceIDChanged>(_onSelectedDeviceIDChanged);
    on<ConditionsChanged>(_onConditionsChanged);
    on<ActionsChanged>(_onActionsChanged);
  }

  final UserRepository _userRepository;

  void _onNameChanged(NameChanged event, Emitter<EditAlertState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onSelectedDeviceIDChanged(
    SelectedDeviceIDChanged event,
    Emitter<EditAlertState> emit,
  ) {
    emit(state.copyWith(selectedDeviceID: event.selectedDeviceID));
  }

  void _onConditionsChanged(
    ConditionsChanged event,
    Emitter<EditAlertState> emit,
  ) {
    emit(state.copyWith(conditions: event.conditions));
  }

  void _onActionsChanged(ActionsChanged event, Emitter<EditAlertState> emit) {
    emit(state.copyWith(actions: event.actions));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditAlertState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditAlertStatus.processing));
      final alert = state.initialAlert?.copyWith(
            name: state.name,
            deviceID: state.selectedDeviceID,
          ) ??
          Alert(
            id: state.id,
            name: state.name,
            deviceID: state.selectedDeviceID!,
          );
      await _userRepository.saveAlert(alert);

      final initialConditionView = {
        for (final cd in state.initialConditions) cd.id: cd
      };
      // handle new conditions
      final newCondition = state.conditions
          .where((cd) => !initialConditionView.containsKey(cd.id)).toList();
      for (final cd in newCondition) {
        await _userRepository.saveCondition(cd);
      }
      // handle editted conditions
      final edittedConditions = state.conditions
          .where(
            (cd) =>
                initialConditionView.containsKey(cd.id) &&
                cd != initialConditionView[cd.id],
          )
          .toList();
      for (final cd in edittedConditions) {
        await _userRepository.saveCondition(cd);
      }
      // handle deleted condition
      final deletedConditions = state.initialConditions
          .where((cd) => !state.conditionView.containsKey(cd.id))
          .toList();
      for (final cd in deletedConditions) {
        await _userRepository.deleteCondition(cd.id);
      }
      // action
      final initialActionView = {
        for (final ac in state.initialActions) ac.id: ac
      };
      // handle new actions
      final newAction =
          state.actions.where((ac) => !initialActionView.containsKey(ac.id));
      for (final ac in newAction) {
        await _userRepository.saveAction(ac);
      }
      // handle editted actions
      final edittedActions = state.actions
          .where(
            (ac) =>
                initialActionView.containsKey(ac.id) &&
                ac != initialActionView[ac.id],
          )
          .toList();
      for (final ac in edittedActions) {
        await _userRepository.saveAction(ac);
      }
      // handle deleted action
      final deletedActions = state.initialActions
          .where((ac) => !state.actionView.containsKey(ac.id))
          .toList();
      for (final ac in deletedActions) {
        await _userRepository.deleteAction(ac.id);
      }

      emit(state.copyWith(status: EditAlertStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditAlertStatus.failure, error: () => err));
      emit(state.copyWith(status: EditAlertStatus.normal, error: () => null));
    }
  }
}
