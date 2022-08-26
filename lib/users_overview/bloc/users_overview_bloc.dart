import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'users_overview_event.dart';
part 'users_overview_state.dart';

class UsersOverviewBloc extends Bloc<UsersOverviewEvent, UsersOverviewState> {
  UsersOverviewBloc(
    this._userRepository, {
    required Project? parentProject,
    required bool isAdmin,
  }) : super(
          UsersOverviewState(
            parentProject: parentProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<UserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<UserProjectSubscriptionRequested>(_onUserProjectSubscriptionRequested);
    on<ProjectSubscriptionRequested>(_onProjectSubscriptionRequested);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<UsersOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UsersOverviewStatus.processing));
      await _userRepository.deleteUser(event.userID);
      emit(state.copyWith(status: UsersOverviewStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(status: UsersOverviewStatus.failure, error: () => err),
      );
      emit(
        state.copyWith(status: UsersOverviewStatus.normal, error: () => null),
      );
    }
  }

  Future<void> _onUserSubscriptionRequested(
    UserSubscriptionRequested event,
    Emitter<UsersOverviewState> emit,
  ) async {
    await emit.forEach<List<User>>(
      _userRepository.subscribeUserStream(),
      onData: (users) {
        return state.copyWith(users: users);
      },
    );
  }

  Future<void> _onProjectSubscriptionRequested(
    ProjectSubscriptionRequested event,
    Emitter<UsersOverviewState> emit,
  ) async {
    await emit.forEach<List<Project>>(
      _userRepository.subscribeProjectStream(),
      onData: (projects) {
        return state.copyWith(projects: projects);
      },
    );
  }

  Future<void> _onUserProjectSubscriptionRequested(
    UserProjectSubscriptionRequested event,
    Emitter<UsersOverviewState> emit,
  ) async {
    await emit.forEach<List<UserProject>>(
      _userRepository.subscribeUserProjectStream(),
      onData: (userProjects) {
        return state.copyWith(userProjects: userProjects);
      },
    );
  }
}
