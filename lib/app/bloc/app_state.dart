part of 'app_bloc.dart';

enum AppStatus {
  userAuthenticated,
  adminAuthenticated,
  unauthenticated,
}

extension AppStatusX on AppStatus {
  bool isUserAuthenticated() => this == AppStatus.userAuthenticated;
  bool isAdminAuthenticated() => this == AppStatus.adminAuthenticated;
  bool isUnauthenticated() => this == AppStatus.unauthenticated;
}

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.unauthenticated,
  });

  final AppStatus status;

  @override
  List<Object> get props => [status];

  AppState copyWith({
    AppStatus? status,
  }) {
    return AppState(
      status: status ?? this.status,
    );
  }
}
