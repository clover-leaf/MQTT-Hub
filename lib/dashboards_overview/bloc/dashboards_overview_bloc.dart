import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'dashboards_overview_event.dart';
part 'dashboards_overview_state.dart';

class DashboardsOverviewBloc
    extends Bloc<DashboardsOverviewEvent, DashboardsOverviewState> {
  DashboardsOverviewBloc(
    this._userRepository, {
    required Project parentProject,
    required bool isAdmin,
  }) : super(
          DashboardsOverviewState(
            parentProject: parentProject,
            isAdmin: isAdmin,
          ),
        ) {
    on<DashboardSubscriptionRequested>(_onDashboardSubcribed);
    on<DeletionRequested>(_onDeleted);
  }

  final UserRepository _userRepository;

  Future<void> _onDeleted(
    DeletionRequested event,
    Emitter<DashboardsOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DashboardsOverviewStatus.processing));
      await _userRepository.deleteDashboard(event.dashboardID);
      emit(state.copyWith(status: DashboardsOverviewStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: DashboardsOverviewStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: DashboardsOverviewStatus.normal,
          error: () => null,
        ),
      );
    }
  }

  Future<void> _onDashboardSubcribed(
    DashboardSubscriptionRequested event,
    Emitter<DashboardsOverviewState> emit,
  ) async {
    await emit.forEach<List<Dashboard>>(
      _userRepository.subscribeDashboardStream(),
      onData: (dashboards) {
        return state.copyWith(dashboards: dashboards);
      },
    );
  }
}
