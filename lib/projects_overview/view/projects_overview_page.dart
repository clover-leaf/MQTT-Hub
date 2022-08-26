import 'package:bee/gen/colors.gen.dart';
import 'package:bee/projects_overview/projects_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ProjectsOverviewPage extends StatelessWidget {
  const ProjectsOverviewPage({super.key});

  static PageRoute<void> route({required bool isAdmin}) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => ProjectsOverviewBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
        )
          ..add(const ProjectSubscriptionRequested())
          ..add(const BrokerSubscriptionRequested())
          ..add(const UserProjectSubscriptionRequested())
          ..add(const DashboardSubscriptionRequested()),
        child: const ProjectsOverviewPage(),
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
      body: ProjectsOverviewView(),
    );
  }
}
