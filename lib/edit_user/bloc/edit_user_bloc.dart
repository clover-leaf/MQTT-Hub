import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc(
    this._userRepository, {
    // new: this is current project
    // update: null
    required Project? initProject,
    required List<UserProject> initUserProjects,
  }) : super(
          EditUserState(
            initUserProjects: initUserProjects,
            selectedProjectIDs: initProject != null
                ? [initProject.id]
                : initUserProjects.map((uspr) => uspr.projectID).toList(),
          ),
        ) {
    on<EditSubmitted>(_onSubmitted);
    on<EditUsernameChanged>(_onUsernameChanged);
    on<EditPasswordChanged>(_onPasswordChanged);
    on<EditProjectAdded>(_onProjectAdded);
    on<EditProjectDeleted>(_onProjectDeleted);
    on<ProjectSubscriptionRequested>(_onProjectSubscriptionRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onProjectSubscriptionRequested(
    ProjectSubscriptionRequested event,
    Emitter<EditUserState> emit,
  ) async {
    await emit.forEach<List<Project>>(
      _userRepository.subscribeProjectStream(),
      onData: (projects) {
        return state.copyWith(projects: projects);
      },
    );
  }

  void _onUsernameChanged(
    EditUsernameChanged event,
    Emitter<EditUserState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        valid: Formz.validate([username]).isValid,
      ),
    );
  }

  void _onPasswordChanged(
    EditPasswordChanged event,
    Emitter<EditUserState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        valid: Formz.validate([password]).isValid,
      ),
    );
  }

  void _onProjectAdded(
    EditProjectAdded event,
    Emitter<EditUserState> emit,
  ) {
    final selectedProjectIDs = List<FieldId>.from(state.selectedProjectIDs)
      ..add(event.projectID);
    emit(state.copyWith(selectedProjectIDs: selectedProjectIDs));
  }

  void _onProjectDeleted(
    EditProjectDeleted event,
    Emitter<EditUserState> emit,
  ) {
    final selectedProjectIDs = List<FieldId>.from(state.selectedProjectIDs)
      ..remove(event.projectID);
    emit(
      state.copyWith(
        selectedProjectIDs: selectedProjectIDs,
        valid: selectedProjectIDs.isNotEmpty,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSubmitted event,
    Emitter<EditUserState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress || !state.valid) {
        emit(state.copyWith(error: 'Please fill infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      // upsert user
      final user = state.initUser
              ?.copyWith(username: event.username, password: event.password) ??
          User(
            username: event.username,
            password: event.password,
          );
      await _userRepository.saveUser(user);
      // delete user-project
      final deletedUserProject = state.initUserProjects
          .where((uspr) => !event.selectedProjectIDs.contains(uspr.projectID));
      for (final usPr in deletedUserProject) {
        await _userRepository.deleteUserProject(usPr.id);
      }
      // add user-project
      final addProjectIDs = event.selectedProjectIDs.where(
        // state.initProjects not contain project
        (prID) => state.initUserProjects
            .where((uspr) => uspr.projectID == prID)
            .isEmpty,
      );
      for (final prID in addProjectIDs) {
        final usPr = UserProject(projectID: prID, userID: user.id);
        await _userRepository.saveUserProject(usPr);
      }
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (error) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          error: error.toString(),
        ),
      );
    }
  }
}
