import 'package:bee/edit_device/edit_device.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class EditDevicePage extends StatelessWidget {
  const EditDevicePage({
    super.key,
    required this.initialID,
    required this.initialDevice,
    required this.initialAttributes,
    required this.initialSelectedBroker,
  });

  final String initialID;
  final Device? initialDevice;
  final List<Attribute> initialAttributes;
  final Broker? initialSelectedBroker;

  static PageRoute<void> route({
    required String parentGroupID,
    required List<Broker> brokers,
    required List<Attribute> initialAttributes,
    required Device? initialDevice,
  }) {
    final initialID = initialDevice?.id ?? const Uuid().v4();
    final initialBrokerID = initialDevice?.brokerID;
    final brokerView = {for (final br in brokers) br.id: br};
    final initialSelectedBroker = brokerView[initialBrokerID];

    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditDeviceBloc(
          context.read<UserRepository>(),
          initialID: initialID,
          parentGroupID: parentGroupID,
          brokers: brokers,
          initialAttributes: initialAttributes,
          initialDevice: initialDevice,
        ),
        child: EditDevicePage(
          initialID: initialID,
          initialDevice: initialDevice,
          initialAttributes: initialAttributes,
          initialSelectedBroker: initialSelectedBroker,
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
      body: EditDeviceView(
        initialID: initialID,
        initialDevice: initialDevice,
        initialAttributes: initialAttributes,
        initialSelectedBroker: initialSelectedBroker,
      ),
    );
  }
}
