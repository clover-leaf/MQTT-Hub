import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'tiles_overview_event.dart';
part 'tiles_overview_state.dart';

class TilesOverviewBloc extends Bloc<TilesOverviewEvent, TilesOverviewState> {
  TilesOverviewBloc(this._userRepository) : super(const TilesOverviewState()) {
    on<TilesOverviewInitializationRequested>(_onInitialized);
    on<TilesOverviewLogoutRequested>(_onLogout);
  }

  final UserRepository _userRepository;

  Future<void> _onInitialized(
    TilesOverviewInitializationRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await _userRepository.getProjects();
    await _userRepository.getGroups();
    await _userRepository.getDevices();
  }

  void _onLogout(
    TilesOverviewLogoutRequested event,
    Emitter<TilesOverviewState> emit,
  ) {
    emit(state.copyWith(status: TilesOverviewStatus.logout));
  }
}
