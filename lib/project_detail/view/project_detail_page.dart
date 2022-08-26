import 'package:bee/gen/colors.gen.dart';
import 'package:bee/project_detail/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key});

  static PageRoute<void> route({
    required bool isAdmin,
    required Project project,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => ProjectDetailBloc(
          context.read<UserRepository>(),
          project: project,
          isAdmin: isAdmin,
        )
          ..add(const GroupSubscriptionRequested())
          ..add(const BrokerSubscriptionRequested())
          ..add(const UserProjectSubscriptionRequested())
          ..add(const DashboardSubscriptionRequested()),
        child: const ProjectDetailPage(),
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
      body: ProjectDetailView(),
    );
  }
}
