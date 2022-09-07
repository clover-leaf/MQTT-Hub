import 'package:bee/components/component.dart';
import 'package:bee/edit_device/bloc/edit_device_bloc.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class DeviceTypeSheet extends StatelessWidget {
  const DeviceTypeSheet({
    super.key,
    required this.onDeviceTypeSelect,
  });

  final void Function(DeviceType) onDeviceTypeSelect;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;

        final selectedDeviceTypeID = state.selectedDeviceTypeID;
        final deviceTypes = state.deviceTypes;

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
              if (deviceTypes.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  alignment: Alignment.center,
                  height: 96,
                  child: Text(
                    'There is no device type in this project',
                    style: textTheme.titleSmall,
                  ),
                )
              else
                ...deviceTypes.map(
                  (dT) => TDeviceTypeItem(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    title: dT.name,
                    isSelected: dT.id == selectedDeviceTypeID,
                    onPressed: () => onDeviceTypeSelect(dT),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
