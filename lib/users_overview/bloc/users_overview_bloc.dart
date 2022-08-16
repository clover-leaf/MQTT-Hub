import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'users_overview_event.dart';
part 'users_overview_state.dart';

class UsersOverviewBloc extends Bloc<UsersOverviewEvent, UsersOverviewState> {
  UsersOverviewBloc(this._userRepository, {required Project? parentProject})
      : super(UsersOverviewState(parentProject: parentProject)) {
    on<UserAdded>(_onUserAdded);
    on<UserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<UserProjectSubscriptionRequested>(_onUserProjectSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onUserAdded(
    UserAdded event,
    Emitter<UsersOverviewState> emit,
  ) async {
    try {
      final usPr =
          UserProject(projectID: event.project.id, userID: event.user.id);
      await _userRepository.saveUserProject(usPr);
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
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
