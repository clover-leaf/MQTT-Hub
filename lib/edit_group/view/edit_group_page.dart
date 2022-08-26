import 'package:bee/edit_group/edit_group.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class EditGroupPage extends StatelessWidget {
  const EditGroupPage({super.key, required this.initialGroup});

  final Group? initialGroup;

  static PageRoute<void> route({
    required FieldId? parentProjetID,
    required FieldId? parentGroupID,
    required Group? initialGroup,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditGroupBloc(
          context.read<UserRepository>(),
          parentProjetID: parentProjetID,
          parentGroupID: parentGroupID,
          initialGroup: initialGroup,
        ),
        child: EditGroupPage(initialGroup: initialGroup),
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
      body: EditGroupView(initialGroup: initialGroup),
    );
  }
}
