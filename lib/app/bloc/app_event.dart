part of 'app_bloc.dart';

class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppAuthenticatorSubscribed extends AppEvent {
  const AppAuthenticatorSubscribed();
  
  @override
  List<Object> get props => [];
}

class AppUnauthenticated extends AppEvent {
  const AppUnauthenticated();
  
  @override
  List<Object> get props => [];
}

class AppAuthenticated extends AppEvent {
  const AppAuthenticated();

  @override
  List<Object> get props => [];
}
