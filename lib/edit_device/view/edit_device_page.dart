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
    required this.allAttributes,
    required this.initialAttributes,
    required this.initialSelectedBroker,
    required this.initialSelectedDeviceType,
  });

  final String initialID;
  final Device? initialDevice;
  final List<Attribute> initialAttributes;
  final List<Attribute> allAttributes;
  final Broker? initialSelectedBroker;
  final DeviceType? initialSelectedDeviceType;

  static PageRoute<void> route({
    required String parentGroupID,
    required List<Broker> brokers,
    required List<DeviceType> deviceTypes,
    required List<Attribute> allAttributes,
    required List<Attribute> initialAttributes,
    required Device? initialDevice,
    required bool isUseDeviceType,
    required bool isAdmin,
    required bool isEdit,
  }) {
    final initialID = initialDevice?.id ?? const Uuid().v4();
    final initialBrokerID = initialDevice?.brokerID;
    final brokerView = {for (final br in brokers) br.id: br};
    final initialSelectedBroker = brokerView[initialBrokerID];
    final initialDeviceTypeID = initialDevice?.deviceTypeID;
    final deviceTypeView = {for (final dT in deviceTypes) dT.id: dT};
    final initialSelectedDeviceType = deviceTypeView[initialDeviceTypeID];

    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditDeviceBloc(
          context.read<UserRepository>(),
          isAdmin: isAdmin,
          isEdit: isEdit,
          initialID: initialID,
          parentGroupID: parentGroupID,
          allAttributes: allAttributes,
          brokers: brokers,
          deviceTypes: deviceTypes,
          initialAttributes: initialAttributes,
          initialDevice: initialDevice,
          isUseDeviceType: isUseDeviceType,
        ),
        child: EditDevicePage(
          initialID: initialID,
          initialDevice: initialDevice,
          initialAttributes: initialAttributes,
          allAttributes: allAttributes,
          initialSelectedBroker: initialSelectedBroker,
          initialSelectedDeviceType: initialSelectedDeviceType,
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
        allAttributes: allAttributes,
        initialSelectedBroker: initialSelectedBroker,
        initialSelectedDeviceType: initialSelectedDeviceType,
      ),
    );
  }
}
