import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_group_event.dart';
part 'edit_group_state.dart';

class EditGroupBloc extends Bloc<EditGroupEvent, EditGroupState> {
  EditGroupBloc(
    this._userRepository, {
    required Project? project,
    required Group? group,
    Group? initGroup,
  })  : assert(
          (project == null) || (group == null),
          'Either project or group must be null',
        ),
        super(
          EditGroupState(
            project: project,
            group: group,
            initGroup: initGroup,
          ),
        ) {
    on<EditSubmitted>(_onSubmitted);
    on<EditGroupNameChanged>(_onGroupNameChanged);
  }

  final UserRepository _userRepository;

  void _onGroupNameChanged(
    EditGroupNameChanged event,
    Emitter<EditGroupState> emit,
  ) {
    final groupName = GroupName.dirty(event.groupName);
    emit(
      state.copyWith(
        groupName: groupName,
        valid: Formz.validate([groupName]).isValid,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSubmitted event,
    Emitter<EditGroupState> emit,
  ) async {
    try {
      if (state.status.isSubmissionInProgress || !state.valid) {
        emit(state.copyWith(error: 'Please fill infomation'));
        return;
      }
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final group = state.initGroup?.copyWith(name: event.groupName) ??
          Group(
            projectID: state.project?.id,
            groupID: state.group?.id,
            name: event.groupName,
          );
      await _userRepository.saveGroup(group);
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
