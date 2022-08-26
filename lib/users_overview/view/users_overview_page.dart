import 'package:bee/gen/colors.gen.dart';
import 'package:bee/users_overview/users_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class UsersOverviewPage extends StatelessWidget {
  const UsersOverviewPage({super.key});

  static PageRoute<void> route(
      {required bool isAdmin, required Project? parentProject,}) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => UsersOverviewBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          parentProject: parentProject,
        )
          ..add(const UserSubscriptionRequested())
          ..add(const ProjectSubscriptionRequested())
          ..add(const UserProjectSubscriptionRequested()),
        child: const UsersOverviewPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin =
            parentProject != null ? const Offset(1, 0) : const Offset(0, 1);
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
      body: UsersOverviewView(),
    );
  }
}
