part of 'tiles_overview_bloc.dart';

enum TilesOverviewStatus {
  initialized,
  logout,
}

extension TilesOverviewStatusX on TilesOverviewStatus{
  bool isInitialized() => this == TilesOverviewStatus.initialized;
  bool isLogout() => this == TilesOverviewStatus.logout;
}

class TilesOverviewState extends Equatable {
  const TilesOverviewState({
    this.status = TilesOverviewStatus.initialized,
  });

  final TilesOverviewStatus status;

  @override
  List<Object> get props => [status];

  TilesOverviewState copyWith({TilesOverviewStatus? status}) {
    return TilesOverviewState(
      status: status ?? this.status,
    );
  }
}
