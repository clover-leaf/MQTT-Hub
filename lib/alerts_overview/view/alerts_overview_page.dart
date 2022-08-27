import 'package:bee/alerts_overview/alerts_overview.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class AlertsOverviewPage extends StatelessWidget {
  const AlertsOverviewPage({super.key});

  static PageRoute<void> route({
    required bool isAdmin,
    required Project parentProject,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => AlertsOverviewBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          parentProject: parentProject,
        )
          ..add(const AlertSubscriptionRequested())
          ..add(const ConditionSubscriptionRequested())
          ..add(const ActionSubscriptionRequested())
          ..add(const BrokerSubscriptionRequested())
          ..add(const DeviceSubscriptionRequested())
          ..add(const AttributeSubscriptionRequested()),
        child: const AlertsOverviewPage(),
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
      body: AlertsOverviewView(),
    );
  }
}
