import 'package:bee/gen/colors.gen.dart';
import 'package:bee/schedules_overview/schedules_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SchedulesOverviewPage extends StatelessWidget {
  const SchedulesOverviewPage({super.key});

  static PageRoute<void> route({
    required bool isAdmin,
    required Project parentProject,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => SchedulesOverviewBloc(
          context.read<UserRepository>(),
          parentProject: parentProject,
          isAdmin: isAdmin,
        )
          ..add(const ScheduleSubscriptionRequested())
          ..add(const BrokerSubscriptionRequested())
          ..add(const ActionSubscriptionRequested())
          ..add(const DeviceSubscriptionRequested())
          ..add(const AttributeSubscriptionRequested()),
        child: const SchedulesOverviewPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
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
      body: SchedulesOverviewView(),
    );
  }
}
