import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_group_event.dart';
part 'edit_group_state.dart';

class EditGroupBloc extends Bloc<EditGroupEvent, EditGroupState> {
  EditGroupBloc(
    this._userRepository, {
    required String? parentProjetID,
    required String? parentGroupID,
    Group? initialGroup,
  })  : assert(
          (parentProjetID == null) || (parentGroupID == null),
          'Either project or group must be null',
        ),
        super(
          EditGroupState(
            parentProjetID: parentProjetID,
            parentGroupID: parentGroupID,
            initialGroup: initialGroup,
            name: initialGroup?.name ?? '',
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
  }

  final UserRepository _userRepository;

  void _onNameChanged(NameChanged event, Emitter<EditGroupState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<EditGroupState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditGroupState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditGroupStatus.processing));
      final group = state.initialGroup?.copyWith(
            name: state.name,
            description: state.description,
          ) ??
          Group(
            projectID: state.parentProjetID,
            groupID: state.parentGroupID,
            name: state.name,
            description: state.description,
          );
      await _userRepository.saveGroup(group);
      emit(state.copyWith(status: EditGroupStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditGroupStatus.failure, error: () => err));
      emit(state.copyWith(status: EditGroupStatus.normal, error: () => null));
    }
  }
}
