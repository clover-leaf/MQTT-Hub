import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'logs_overview_event.dart';
part 'logs_overview_state.dart';

class LogsOverviewBloc extends Bloc<LogsOverviewEvent, LogsOverviewState> {
  LogsOverviewBloc(this._userRepository) : super(LogsOverviewState()) {
    on<AttributeSubscriptionRequested>(_onAttributeSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<LogSubscriptionRequested>(_onLogSubscribed);
    on<AlertSubscriptionRequested>(_onAlertSubscribed);
    on<ConditionLogSubscriptionRequested>(_onConditionLogSubscribed);
  }

  final UserRepository _userRepository;

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<LogsOverviewState> emit,
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
    Emitter<LogsOverviewState> emit,
  ) async {
    await emit.forEach<List<Attribute>>(
      _userRepository.subscribeAttributeStream(),
      onData: (attributes) {
        return state.copyWith(attributes: attributes);
      },
    );
  }

  Future<void> _onLogSubscribed(
    LogSubscriptionRequested event,
    Emitter<LogsOverviewState> emit,
  ) async {
    await emit.forEach<List<Log>>(
      _userRepository.subscribeLogStream(),
      onData: (logs) {
        return state.copyWith(logs: logs);
      },
    );
  }

  Future<void> _onConditionLogSubscribed(
    ConditionLogSubscriptionRequested event,
    Emitter<LogsOverviewState> emit,
  ) async {
    await emit.forEach<List<ConditionLog>>(
      _userRepository.subscribeConditionLogStream(),
      onData: (conditionLogs) {
        return state.copyWith(conditionLogs: conditionLogs);
      },
    );
  }

  Future<void> _onAlertSubscribed(
    AlertSubscriptionRequested event,
    Emitter<LogsOverviewState> emit,
  ) async {
    await emit.forEach<List<Alert>>(
      _userRepository.subscribeAlertStream(),
      onData: (alerts) {
        return state.copyWith(alerts: alerts);
      },
    );
  }
}
