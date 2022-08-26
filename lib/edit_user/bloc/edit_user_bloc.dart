import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc(
    this._userRepository, {
    required String userID,
    required List<Project> initialProjects,
    required List<UserProject> initialUserProjects,
    required User? initialUser,
  }) : super(
          EditUserState(
            initialUserProjects: initialUserProjects,
            initialProjects: initialProjects,
            initialUser: initialUser,
            userID: userID,
            userProjects: initialUserProjects,
            username: initialUser?.username ?? '',
            password: initialUser?.password ?? '',
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<UserProjectsChanged>(_onUserProjectsChanged);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(UsernameChanged event, Emitter<EditUserState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<EditUserState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onUserProjectsChanged(
    UserProjectsChanged event,
    Emitter<EditUserState> emit,
  ) {
    emit(state.copyWith(userProjects: event.userProjects));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditUserState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditUserStatus.processing));
      // upsert user
      final user = User(
        id: state.userID,
        username: state.username,
        password: state.password,
      );
      await _userRepository.saveUser(user);

      final initialUsPrView = {
        for (final usPr in state.initialUserProjects) usPr.projectID: usPr
      };
      final usPrView = {
        for (final usPr in state.userProjects) usPr.projectID: usPr
      };

      final newUsPrs = state.userProjects
          .where((usPr) => !initialUsPrView.keys.contains(usPr.projectID))
          .toList();
      for (final usPr in newUsPrs) {
        await _userRepository.saveUserProject(usPr);
      }

      final deletedUsPrs = state.initialUserProjects
          .where((usPr) => !usPrView.keys.contains(usPr.projectID))
          .toList();
      for (final usPr in deletedUsPrs) {
        await _userRepository.deleteUserProject(usPr.id);
      }
      emit(state.copyWith(status: EditUserStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditUserStatus.failure, error: () => err));
      emit(state.copyWith(status: EditUserStatus.normal, error: () => null));
    }
  }
}
