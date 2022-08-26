import 'package:bee/brokers_overview/brokers_overview.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class BrokersOverviewPage extends StatelessWidget {
  const BrokersOverviewPage({super.key});

  static PageRoute<void> route({
    required bool isAdmin,
    required Project parentProject,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => BrokersOverviewBloc(
          context.read<UserRepository>(),
          parentProject: parentProject,
          isAdmin: isAdmin,
        )..add(const BrokerSubscriptionRequested()),
        child: const BrokersOverviewPage(),
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
      body: BrokersOverviewView(),
    );
  }
}
