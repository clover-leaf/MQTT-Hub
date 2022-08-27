import 'package:bee/edit_alert/edit_alert.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class EditAlertPage extends StatelessWidget {
  const EditAlertPage({
    super.key,
    required this.initialID,
    required this.initialAlert,
    required this.initialSelectedDevice,
    required this.attributes,
    required this.initialConditions,
    required this.initialActions,
  });

  final String initialID;
  final Alert? initialAlert;
  final Device? initialSelectedDevice;
  final List<Attribute> attributes;
  final List<Condition> initialConditions;
  final List<TAction> initialActions;

  static PageRoute<void> route({
    required List<Attribute> attributes,
    required List<Device> devices,
    required List<Condition> initialConditions,
    required List<TAction> initialActions,
    required Alert? initialAlert,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        final initialID = initialAlert?.id ?? const Uuid().v4();
        final deviceView = {for (final br in devices) br.id: br};
        final initialDeviceID = initialAlert?.deviceID;
        final initialSelectedDevice = deviceView[initialDeviceID];

        return BlocProvider(
          create: (context) => EditAlertBloc(
            context.read<UserRepository>(),
            devices: devices,
            attributes: attributes,
            initialConditions: initialConditions,
            initialActions: initialActions,
            initialAlert: initialAlert,
            initialID: initialID,
          ),
          child: EditAlertPage(
            initialID: initialID,
            initialAlert: initialAlert,
            initialSelectedDevice: initialSelectedDevice,
            attributes: attributes,
            initialConditions: initialConditions,
            initialActions: initialActions,
          ),
        );
      },
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
      body: EditAlertView(
        initialID: initialID,
        initialAlert: initialAlert,
        initialSelectedDevice: initialSelectedDevice,
        attributes: attributes,
        initialConditions: initialConditions,
        initialActions: initialActions,
      ),
    );
  }
}
