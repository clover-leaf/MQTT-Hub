import 'package:bee/components/component.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class DeviceSheet extends StatelessWidget {
  const DeviceSheet({
    super.key,
    required this.selectedDeviceID,
    required this.devices,
    required this.onDeviceSelected,
  });

  final String? selectedDeviceID;
  final List<Device> devices;
  final void Function(Device) onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      decoration: const BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
            child: Text(
              'DEVICES',
              style: textTheme.titleSmall,
            ),
          ),
          if (devices.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.center,
              height: 96,
              child: Text(
                'There is no device in this project',
                style: textTheme.titleSmall,
              ),
            )
          else
            ...devices.map(
              (dv) => TBrokerItem(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: dv.name,
                subtitle: dv.topic,
                isSelected: dv.id == selectedDeviceID,
                onPressed: () => onDeviceSelected(dv),
              ),
            )
        ],
      ),
    );
  }
}
