import 'package:bee/edit_dashboard/edit_dashboard.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class EditDashboardPage extends StatelessWidget {
  const EditDashboardPage({super.key, required this.initialDashboard});

  final Dashboard? initialDashboard;

  static PageRoute<void> route({
    required Project project,
    required Dashboard? initialDashboard,
    required bool isAdmin,
    required bool isEdit,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditDashboardBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          isEdit: isEdit,
          parentProject: project,
          initialDashboard: initialDashboard,
        ),
        child: EditDashboardPage(initialDashboard: initialDashboard),
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
    return Scaffold(
      backgroundColor: ColorName.white,
      body: EditDashboardView(
        initialName: initialDashboard?.name,
      ),
    );
  }
}
