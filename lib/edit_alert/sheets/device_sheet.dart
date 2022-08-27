import 'package:bee/components/component.dart';
import 'package:bee/edit_alert/bloc/edit_alert_bloc.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class DeviceSheet extends StatelessWidget {
  const DeviceSheet({
    super.key,
    required this.onDeviceSelected,
  });

  final void Function(Device) onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAlertBloc, EditAlertState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;

        final selectedDeviceID = state.selectedDeviceID;
        final devices = state.devices;

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
      },
    );
  }
}
