import 'package:bee/components/t_selected_box.dart';
import 'package:bee/edit_tile/edit_tile.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class DeviceAttributeFIeld extends StatefulWidget {
  const DeviceAttributeFIeld({
    super.key,
    required this.devices,
    required this.initialDevice,
    required this.initialAttribute,
    required this.enabled,
  });

  final List<Device> devices;
  final Device? initialDevice;
  final Attribute? initialAttribute;
  final bool enabled;

  @override
  State<DeviceAttributeFIeld> createState() => _DeviceAttributeFIeldState();
}

class _DeviceAttributeFIeldState extends State<DeviceAttributeFIeld> {
  late Device? selectedDevice;
  late Attribute? selectedAttrbute;

  @override
  void initState() {
    selectedDevice = widget.initialDevice;
    selectedAttrbute = widget.initialAttribute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: [selectedDevice, selectedAttrbute],
      validator: (_) {
        if (selectedDevice == null || selectedAttrbute == null) {
          return null;
        } else if (selectedDevice!.deviceTypeID != null) {
          if (selectedAttrbute!.deviceTypeID != selectedDevice!.deviceTypeID) {
            return 'Attribute must belong to monitoring device';
          } else {
            return null;
          }
        } else if (selectedAttrbute!.deviceID != selectedDevice!.id) {
          return 'Attribute must belong to monitoring device';
        } else {
          return null;
        }
      },
      builder: (dvattFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TSelectedField(
            labelText: 'Monitoring Device',
            initialValue: selectedDevice?.name,
            picture: Assets.icons.airdrop,
            enabled: widget.enabled,
            onTapped: () async => showMaterialModalBottomSheet<Device?>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (bContext) => BlocProvider.value(
                value: BlocProvider.of<EditTileBloc>(context),
                child: DeviceSheet(
                  // when select device, return device
                  onDeviceSelected: (device) =>
                      Navigator.of(bContext).pop(device),
                ),
              ),
            ).then((device) {
              if (device != null) {
                context.read<EditTileBloc>().add(DeviceIDChanged(device.id));
                setState(() {
                  selectedDevice = device;
                });
                return device.name;
              }
              return null;
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Device must not be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          TSelectedField(
            labelText: 'Monitoring Attribute',
            initialValue: selectedAttrbute?.name,
            picture: Assets.icons.autobrightness,
            enabled: widget.enabled,
            onTapped: () async => showMaterialModalBottomSheet<Attribute?>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (bContext) => BlocProvider.value(
                value: BlocProvider.of<EditTileBloc>(context),
                child: AttributeSheet(
                  // when select attribute, return attribute
                  onAttributeSeleted: (attribute) =>
                      Navigator.of(bContext).pop(attribute),
                ),
              ),
            ).then((attribute) {
              if (attribute != null) {
                context
                    .read<EditTileBloc>()
                    .add(AttributeIDChanged(attribute.id));
                setState(() {
                  selectedAttrbute = attribute;
                });
                return attribute.name;
              }
              return null;
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Attribute must not be empty';
              }
              return null;
            },
          ),
          // List ranges error line
          if (dvattFormFieldState.hasError) const SizedBox(height: 8),
          if (dvattFormFieldState.hasError)
            Text(
              dvattFormFieldState.errorText!,
              style: textTheme.labelMedium!.copyWith(
                color: ColorName.wine300,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
