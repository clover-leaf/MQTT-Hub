import 'package:bee/edit_broker/edit_broker.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class EditBrokerPage extends StatelessWidget {
  const EditBrokerPage({
    super.key,
    required this.initialBroker,
  });

  final Broker? initialBroker;

  static PageRoute<void> route({
    required Project project,
    required Broker? initialBroker,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditBrokerBloc(
          context.read<UserRepository>(),
          parentProject: project,
          initialBroker: initialBroker,
        ),
        child: EditBrokerPage(initialBroker: initialBroker),
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
      body: EditBrokerView(
        initialName: initialBroker?.name,
        initialUrl: initialBroker?.url,
        initialPort: initialBroker?.port.toString(),
        initialAccount: initialBroker?.account,
        initialPassword: initialBroker?.password,
        initialBroker: initialBroker,
      ),
    );
  }
}
