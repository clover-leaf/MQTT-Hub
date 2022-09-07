import 'package:bee/edit_device_type/edit_device_type.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class EditDeviceTypePage extends StatelessWidget {
  const EditDeviceTypePage({
    super.key,
    required this.initialID,
    required this.initialDeviceType,
    required this.initialAttributes,
  });

  final String initialID;
  final DeviceType? initialDeviceType;
  final List<Attribute> initialAttributes;

  static PageRoute<void> route({
    required String parentProjectID,
    required List<Attribute> initialAttributes,
    required DeviceType? initialDeviceType,
    required bool isAdmin,
    required bool isEdit,
  }) {
    final initialID = initialDeviceType?.id ?? const Uuid().v4();

    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditDeviceTypeBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          isEdit: isEdit,
          initialID: initialID,
          parentProjectID: parentProjectID,
          initialAttributes: initialAttributes,
          initialDeviceType: initialDeviceType,
        ),
        child: EditDeviceTypePage(
          initialID: initialID,
          initialDeviceType: initialDeviceType,
          initialAttributes: initialAttributes,
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
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorName.white,
      body: EditDeviceTypeView(
        initialID: initialID,
        initialDeviceType: initialDeviceType,
        initialAttributes: initialAttributes,
      ),
    );
  }
}
