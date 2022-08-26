import 'package:bee/group_detail/group_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  static PageRoute<void> route({
    required bool isAdmin,
    required Project rootProject,
    required Group group,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => GroupDetailBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          rootProject: rootProject,
          group: group,
        )
          ..add(const GroupSubscriptionRequested())
          ..add(const BrokerSubscriptionRequested())
          ..add(const DeviceSubscriptionRequested()),
        child: const GroupDetailPage(),
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
      backgroundColor: Colors.white,
      body: GroupDetailView(),
    );
  }
}
