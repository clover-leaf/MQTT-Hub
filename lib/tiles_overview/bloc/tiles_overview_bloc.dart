
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'tiles_overview_event.dart';
part 'tiles_overview_state.dart';

class TilesOverviewBloc extends Bloc<TilesOverviewEvent, TilesOverviewState> {
  TilesOverviewBloc(this._userRepository) : super(const TilesOverviewState()) {
    on<TilesOverviewEvent>(_onChanged);
  }

  final UserRepository _userRepository;

  void _onChanged(TilesOverviewEvent event, Emitter<TilesOverviewState> emit) {
    emit(
      state.copyWith(),
    );
  }
}
