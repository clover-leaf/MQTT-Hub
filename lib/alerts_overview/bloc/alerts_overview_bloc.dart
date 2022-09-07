import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'alerts_overview_event.dart';
part 'alerts_overview_state.dart';

class AlertsOverviewBloc
    extends Bloc<AlertsOverviewEvent, AlertsOverviewState> {
  AlertsOverviewBloc(
    this._userRepository, {
    required bool isAdmin,
    required Project parentProject,
  }) : super(
          AlertsOverviewState(
            isAdmin: isAdmin,
            parentProject: parentProject,
          ),
        ) {
    on<AlertSubscriptionRequested>(_onAlertSubscribed);
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<ConditionSubscriptionRequested>(_onConditionSubscribed);
    on<ActionSubscriptionRequested>(_onActionSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<AttributeSubscriptionRequested>(_onAttributeSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AlertsOverviewStatus.processing));
      await _userRepository.deleteAlert(event.alertID);
      final deletedConditions =
          state.conditions.where((cd) => cd.alertID == event.alertID).toList();
      for (final cd in deletedConditions) {
        await _userRepository.deleteCondition(cd.id);
      }
      final deletedActions =
          state.actions.where((ac) => ac.alertID == event.alertID).toList();
      for (final ac in deletedActions) {
        await _userRepository.deleteAction(ac.id);
      }
      emit(state.copyWith(status: AlertsOverviewStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(status: AlertsOverviewStatus.failure, error: () => err),
      );
      emit(
        state.copyWith(status: AlertsOverviewStatus.normal, error: () => null),
      );
    }
  }

  Future<void> _onAlertSubscribed(
    AlertSubscriptionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    await emit.forEach<List<Alert>>(
      _userRepository.subscribeAlertStream(),
      onData: (alerts) {
        return state.copyWith(alerts: alerts);
      },
    );
  }

  Future<void> _onConditionSubscribed(
    ConditionSubscriptionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    await emit.forEach<List<Condition>>(
      _userRepository.subscribeConditionStream(),
      onData: (conditions) {
        return state.copyWith(conditions: conditions);
      },
    );
  }

  Future<void> _onActionSubscribed(
    ActionSubscriptionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    await emit.forEach<List<TAction>>(
      _userRepository.subscribeActionStream(),
      onData: (actions) {
        return state.copyWith(actions: actions);
      },
    );
  }

  Future<void> _onBrokerSubscribed(
    BrokerSubscriptionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        return state.copyWith(brokers: brokers);
      },
    );
  }

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    await emit.forEach<List<Device>>(
      _userRepository.subscribeDeviceStream(),
      onData: (devices) {
        return state.copyWith(devices: devices);
      },
    );
  }

  Future<void> _onAttributeSubscribed(
    AttributeSubscriptionRequested event,
    Emitter<AlertsOverviewState> emit,
  ) async {
    await emit.forEach<List<Attribute>>(
      _userRepository.subscribeAttributeStream(),
      onData: (attributes) {
        return state.copyWith(attributes: attributes);
      },
    );
  }
}
