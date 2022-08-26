import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_dashboard_event.dart';
part 'edit_dashboard_state.dart';

class EditDashboardBloc extends Bloc<EditDashboardEvent, EditDashboardState> {
  EditDashboardBloc(
    this._userRepository, {
    required Project parentProject,
    required Dashboard? initialDashboard,
  }) : super(
          EditDashboardState(
            parentProject: parentProject,
            initialDashboard: initialDashboard,
            name: initialDashboard?.name ?? '',
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
  }

  final UserRepository _userRepository;

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditDashboardState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditDashboardStatus.processing));
      final dashboard = state.initialDashboard?.copyWith(
            projectID: state.parentProject.id,
            name: state.name,
          ) ??
          Dashboard(
            projectID: state.parentProject.id,
            name: state.name,
          );
      await _userRepository.saveDashboard(dashboard);
      emit(state.copyWith(status: EditDashboardStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(
          status: EditDashboardStatus.failure, error: () => err,),);
      emit(state.copyWith(
          status: EditDashboardStatus.normal, error: () => null,),);
    }
  }

  void _onNameChanged(NameChanged event, Emitter<EditDashboardState> emit) {
    emit(state.copyWith(name: event.name));
  }
}
