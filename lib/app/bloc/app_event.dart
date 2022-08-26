part of 'app_bloc.dart';

class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppUnauthenticated extends AppEvent {
  const AppUnauthenticated();

  @override
  List<Object> get props => [];
}

class AppAuthenticated extends AppEvent {
  const AppAuthenticated({
    required this.token,
    required this.toWrite,
    required this.isAdmin,
  });

  final String token;
  final bool toWrite;
  final bool isAdmin;

  @override
  List<Object> get props => [token, toWrite, isAdmin];
}
