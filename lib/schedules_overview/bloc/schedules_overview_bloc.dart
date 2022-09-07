import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'schedules_overview_event.dart';
part 'schedules_overview_state.dart';

class SchedulesOverviewBloc
    extends Bloc<SchedulesOverviewEvent, SchedulesOverviewState> {
  SchedulesOverviewBloc(
    this._userRepository, {
    required Project parentProject,
    required bool isAdmin,
  }) : super(
          SchedulesOverviewState(
            parentProject: parentProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<BrokerSubscriptionRequested>(_onBrokerSubcribed);
    on<ScheduleSubscriptionRequested>(_onScheduleSubcribed);
    on<ActionSubscriptionRequested>(_onActionSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<AttributeSubscriptionRequested>(_onAttributeSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<SchedulesOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SchedulesOverviewStatus.processing));
      await _userRepository.deleteSchedule(event.scheduleID);
      emit(state.copyWith(status: SchedulesOverviewStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: SchedulesOverviewStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: SchedulesOverviewStatus.normal,
          error: () => null,
        ),
      );
    }
  }

  Future<void> _onBrokerSubcribed(
    BrokerSubscriptionRequested event,
    Emitter<SchedulesOverviewState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        return state.copyWith(brokers: brokers);
      },
    );
  }

  Future<void> _onScheduleSubcribed(
    ScheduleSubscriptionRequested event,
    Emitter<SchedulesOverviewState> emit,
  ) async {
    await emit.forEach<List<Schedule>>(
      _userRepository.subscribeScheduleStream(),
      onData: (schedules) {
        return state.copyWith(schedules: schedules);
      },
    );
  }

  Future<void> _onActionSubscribed(
    ActionSubscriptionRequested event,
    Emitter<SchedulesOverviewState> emit,
  ) async {
    await emit.forEach<List<TAction>>(
      _userRepository.subscribeActionStream(),
      onData: (actions) {
        return state.copyWith(actions: actions);
      },
    );
  }

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<SchedulesOverviewState> emit,
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
    Emitter<SchedulesOverviewState> emit,
  ) async {
    await emit.forEach<List<Attribute>>(
      _userRepository.subscribeAttributeStream(),
      onData: (attributes) {
        return state.copyWith(attributes: attributes);
      },
    );
  }
}
