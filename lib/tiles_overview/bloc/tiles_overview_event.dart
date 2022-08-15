part of 'tiles_overview_bloc.dart';

class TilesOverviewEvent extends Equatable {
  const TilesOverviewEvent();

  @override
  List<Object?> get props => [];
}

class TilesOverviewInitializationRequested extends TilesOverviewEvent {
  const TilesOverviewInitializationRequested();
}

class TilesOverviewLogoutRequested extends TilesOverviewEvent {
  const TilesOverviewLogoutRequested();
}
