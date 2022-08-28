import 'package:bee/gen/colors.gen.dart';
import 'package:bee/logs_overview/logs_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class LogsOverviewPage extends StatelessWidget {
  const LogsOverviewPage({super.key});

  static PageRoute<void> route() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => LogsOverviewBloc(context.read<UserRepository>())
          ..add(const DeviceSubscriptionRequested())
          ..add(const AttributeSubscriptionRequested())
          ..add(const AlertSubscriptionRequested())
          ..add(const LogSubscriptionRequested())
          ..add(const ConditionLogSubscriptionRequested()),
        child: const LogsOverviewPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorName.white,
      body: LogsOverviewView(),
    );
  }
}
