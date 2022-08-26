import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_project_event.dart';
part 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  EditProjectBloc(this._userRepository, {required Project? initialProject})
      : super(
          EditProjectState(
            initialProject: initialProject,
            name: initialProject?.name ?? '',
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
  }

  final UserRepository _userRepository;

  void _onNameChanged(NameChanged event, Emitter<EditProjectState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditProjectState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditProjectStatus.processing));
      final project = state.initialProject?.copyWith(name: state.name) ??
          Project(name: state.name);
      await _userRepository.saveProject(project);
      if (state.initialProject == null) {
        final dashboard = Dashboard(projectID: project.id, name: 'Default');
        await _userRepository.saveDashboard(dashboard);
      }
      emit(state.copyWith(status: EditProjectStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: EditProjectStatus.failure, error: () => err));
      emit(state.copyWith(status: EditProjectStatus.normal, error: () => null));
    }
  }
}
