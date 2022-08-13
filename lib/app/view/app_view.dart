import 'package:bee/app/app.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:user_repository/user_repository.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  bool isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (isInit) {
      final repository = context.read<UserRepository>();
      try {
        final token = await repository.recoverSession();
        await repository.checkToken(token);
        repository.token = token;
        if (!mounted) return;
        context.read<AppBloc>().add(const AppAuthenticated());
      } catch (err) {
        context.read<AppBloc>().add(const AppUnauthenticated());
      }
      FlutterNativeSplash.remove();
      isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
