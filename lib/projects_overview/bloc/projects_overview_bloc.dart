import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'projects_overview_event.dart';
part 'projects_overview_state.dart';

class ProjectsOverviewBloc
    extends Bloc<ProjectsOverviewEvent, ProjectsOverviewState> {
  ProjectsOverviewBloc(this._userRepository)
      : super(const ProjectsOverviewState()) {
    on<ProjectSubscriptionRequested>(_onProjectSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onProjectSubscriptionRequested(
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
}
