import 'package:bee/edit_project/edit_project.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class EditProjectPage extends StatelessWidget {
  const EditProjectPage({super.key, required this.initialProject});

  final Project? initialProject;

  static PageRoute<void> route({required Project? initialProject}) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditProjectBloc(
          context.read<UserRepository>(),
          initialProject: initialProject,
        ),
        child: EditProjectPage(initialProject: initialProject),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorName.white,
      body: EditProjectView(
        initialProject: initialProject,
        initialName: initialProject?.name,
      ),
    );
  }
}
