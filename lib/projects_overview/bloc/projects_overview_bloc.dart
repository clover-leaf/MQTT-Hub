import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'projects_overview_event.dart';
part 'projects_overview_state.dart';

class ProjectsOverviewBloc
    extends Bloc<ProjectsOverviewEvent, ProjectsOverviewState> {
  ProjectsOverviewBloc(this._userRepository, {required bool isAdmin})
      : super(ProjectsOverviewState(isAdmin: isAdmin)) {
    on<ProjectSubscriptionRequested>(_onProjectSubscribed);
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<UserProjectSubscriptionRequested>(_onUserProjectSubscribed);
    on<DashboardSubscriptionRequested>(_onDashboadSubscribed);
  }

  final UserRepository _userRepository;

  Future<void> _onProjectSubscribed(
    ProjectSubscriptionRequested event,
    Emitter<ProjectsOverviewState> emit,
  ) async {
    await emit.forEach<List<Project>>(
      _userRepository.subscribeProjectStream(),
      onData: (projects) {
        return state.copyWith(projects: projects);
      },
    );
  }

  Future<void> _onBrokerSubscribed(
    BrokerSubscriptionRequested event,
    Emitter<ProjectsOverviewState> emit,
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
    Emitter<ProjectsOverviewState> emit,
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
    Emitter<ProjectsOverviewState> emit,
  ) async {
    await emit.forEach<List<Dashboard>>(
      _userRepository.subscribeDashboardStream(),
      onData: (dashboards) {
        return state.copyWith(dashboards: dashboards);
      },
    );
  }
}
