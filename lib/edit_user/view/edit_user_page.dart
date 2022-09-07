import 'package:bee/edit_user/edit_user.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({
    super.key,
    required this.userID,
    required this.initialUser,
    required this.initialProjects,
    required this.userProjects,
  });

  final String userID;
  final User? initialUser;
  final List<Project> initialProjects;
  final List<UserProject> userProjects;

  static PageRoute<void> route({
    required List<Project> initialProjects,
    required List<UserProject> initialUserProjects,
    required User? initialUser,
    required bool isEdit,
  }) {
    final userID = initialUser?.id ?? const Uuid().v4();
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditUserBloc(
          context.read<UserRepository>(),
          isEdit: isEdit,
          initialProjects: initialProjects,
          initialUserProjects: initialUserProjects,
          initialUser: initialUser,
          userID: userID,
        ),
        child: EditUserPage(
          userID: userID,
          initialUser: initialUser,
          initialProjects: initialProjects,
          userProjects: initialUserProjects,
        ),
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
      body: EditUserView(
        userID: userID,
        initialUser: initialUser,
        initialProjects: initialProjects,
        userProjects: userProjects,
      ),
    );
  }
}
