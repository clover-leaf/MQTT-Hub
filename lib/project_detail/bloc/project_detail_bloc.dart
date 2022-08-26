import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'project_detail_event.dart';
part 'project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  ProjectDetailBloc(this._userRepository,
      {required Project project, required bool isAdmin,})
      : super(ProjectDetailState(project: project, isAdmin: isAdmin)) {
    on<GroupSubscriptionRequested>(_onGroupSubscribed);
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<UserProjectSubscriptionRequested>(_onUserProjectSubscribed);
    on<DashboardSubscriptionRequested>(_onDashboadSubscribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProjectDetailStatus.processing));
      await _userRepository.deleteProject(state.project.id);
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

  Future<void> _onDashboadSubscribed(
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
}
