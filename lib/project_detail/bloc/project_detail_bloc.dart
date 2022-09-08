import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'project_detail_event.dart';
part 'project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  ProjectDetailBloc(
    this._userRepository, {
    required String projectID,
    required bool isAdmin,
  }) : super(ProjectDetailState(projectID: projectID, isAdmin: isAdmin)) {
    on<ProjectSubscriptionRequested>(_onProjectSubscribed);
    on<GroupSubscriptionRequested>(_onGroupSubscribed);
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<UserProjectSubscriptionRequested>(_onUserProjectSubscribed);
    on<DashboardSubscriptionRequested>(_onDashboardSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<AlertSubscriptionRequested>(_onAlertSubscribed);
    on<DeviceTypeSubscriptionRequested>(_onDeviceTypeSubscribed);
    on<ScheduleSubscriptionRequested>(_onScheduleSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProjectDetailStatus.processing));
      await _userRepository.deleteProject(state.projectID);
      emit(state.copyWith(status: ProjectDetailStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: ProjectDetailStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: ProjectDetailStatus.normal,
          error: () => null,
        ),
      );
    }
  }

  Future<void> _onProjectSubscribed(
    ProjectSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Project>>(
      _userRepository.subscribeProjectStream(),
      onData: (projects) {
        return state.copyWith(projects: projects);
      },
    );
  }

  Future<void> _onGroupSubscribed(
    GroupSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Group>>(
      _userRepository.subscribeGroupStream(),
      onData: (groups) {
        return state.copyWith(groups: groups);
      },
    );
  }

  Future<void> _onBrokerSubscribed(
    BrokerSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        return state.copyWith(brokers: brokers);
      },
    );
  }

  Future<void> _onUserProjectSubscribed(
    UserProjectSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<UserProject>>(
      _userRepository.subscribeUserProjectStream(),
      onData: (userProjects) {
        return state.copyWith(userProjects: userProjects);
      },
    );
  }

  Future<void> _onDashboardSubscribed(
    DashboardSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Dashboard>>(
      _userRepository.subscribeDashboardStream(),
      onData: (dashboards) {
        return state.copyWith(dashboards: dashboards);
      },
    );
  }

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Device>>(
      _userRepository.subscribeDeviceStream(),
      onData: (devices) {
        return state.copyWith(devices: devices);
      },
    );
  }

  Future<void> _onDeviceTypeSubscribed(
    DeviceTypeSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<DeviceType>>(
      _userRepository.subscribeDeviceTypeStream(),
      onData: (deviceTypes) {
        return state.copyWith(deviceTypes: deviceTypes);
      },
    );
  }

  Future<void> _onAlertSubscribed(
    AlertSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Alert>>(
      _userRepository.subscribeAlertStream(),
      onData: (alerts) {
        return state.copyWith(alerts: alerts);
      },
    );
  }

  Future<void> _onScheduleSubscribed(
    ScheduleSubscriptionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    await emit.forEach<List<Schedule>>(
      _userRepository.subscribeScheduleStream(),
      onData: (schedules) {
        return state.copyWith(schedules: schedules);
      },
    );
  }
}
