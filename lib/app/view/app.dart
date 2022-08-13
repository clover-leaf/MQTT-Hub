import 'package:bee/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({super.key, required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
        create: (context) =>
            AppBloc(_userRepository)..add(const AppAuthenticatorSubscribed()),
        child: const AppView(),
      ),
    );
  }
}
