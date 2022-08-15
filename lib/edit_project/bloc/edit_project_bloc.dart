import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_project_event.dart';
part 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  EditProjectBloc(this._userRepository, {Project? initProject})
      : super(EditProjectState(initProject: initProject)) {
    on<EditSubmitted>(_onSubmitted);
    on<EditProjectNameChanged>(_onProjectNameChanged);
  }

  final UserRepository _userRepository;

  void _onProjectNameChanged(
    EditProjectNameChanged event,
    Emitter<EditProjectState> emit,
  ) {
    final projectName = ProjectName.dirty(event.projectName);
    emit(
      state.copyWith(
        projectName: projectName,
        valid: Formz.validate([projectName]).isValid,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSubmitted event,
    Emitter<EditProjectState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress || !state.valid) {
        emit(state.copyWith(error: 'Please fill infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final project = state.initProject?.copyWith(name: event.projectName) ??
          Project(name: event.projectName);
      await _userRepository.saveProject(project);
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
