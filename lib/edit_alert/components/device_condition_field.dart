import 'package:bee/components/t_selected_box.dart';
import 'package:bee/edit_alert/edit_alert.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class DeviceConditionField extends StatefulWidget {
  const DeviceConditionField({
    super.key,
    required this.alertID,
    required this.allAttributes,
    required this.initialDevice,
    required this.initialConditions,
    required this.enabled,
  });

  final String alertID;
  final List<Attribute> allAttributes;
  final Device? initialDevice;
  final List<Condition> initialConditions;
  final bool enabled;

  @override
  State<DeviceConditionField> createState() => _DeviceConditionFieldState();
}

class _DeviceConditionFieldState extends State<DeviceConditionField> {
  late final String _alertID;
  late Device? _selectedDevice;
  late List<Condition> _conditions;
  late List<Attribute> _attributesInDevice;
  late Map<String, Attribute> _attributeView;

  @override
  void initState() {
    _alertID = widget.alertID;
    _selectedDevice = widget.initialDevice;
    _conditions = widget.initialConditions;
    _attributesInDevice = widget.allAttributes.where((att) {
      if (_selectedDevice == null) {
        return false;
      } else if (_selectedDevice!.deviceTypeID != null) {
        return att.deviceTypeID == _selectedDevice!.deviceTypeID;
      } else {
        return att.deviceID == _selectedDevice!.id;
      }
    }).toList();
    _attributeView = {for (final att in widget.allAttributes) att.id: att};
    super.initState();
  }

  void updateSelectedDeviceIDBloc(BuildContext context, String deviceID) {
    context.read<EditAlertBloc>().add(SelectedDeviceIDChanged(deviceID));
  }

  void updateConditionsloc(BuildContext context, List<Condition> conditions) {
    context.read<EditAlertBloc>().add(ConditionsChanged(conditions));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FormField(
      initialValue: [_selectedDevice, _conditions],
      validator: (_) {
        for (final cd in _conditions) {
          final attributeOfCondition = _attributeView[cd.attributeID];
          // device is using device type
          if (_selectedDevice?.deviceTypeID != null) {
            if (attributeOfCondition?.deviceTypeID !=
                _selectedDevice?.deviceTypeID) {
              return 'All attributes must belong to device';
            } else {
              return null;
            }
          }
          // device not using device type
          else if (attributeOfCondition?.deviceID != _selectedDevice?.id) {
            return 'All attributes must belong to device';
          }
        }
        return null;
      },
      builder: (dvcdFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TSelectedField(
            labelText: 'Device',
            initialValue: _selectedDevice?.name,
            picture: Assets.icons.airdrop,
            enabled: widget.enabled,
            onTapped: () async => showMaterialModalBottomSheet<Device?>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (bContext) => BlocProvider.value(
                value: BlocProvider.of<EditAlertBloc>(context),
                child: DeviceSheet(
                  selectedDeviceID: _selectedDevice?.id,
                  // when select device, return device
                  onDeviceSelected: (device) =>
                      Navigator.of(bContext).pop(device),
                ),
              ),
            ).then((device) {
              if (device != null) {
                updateSelectedDeviceIDBloc(context, device.id);
                setState(() {
                  _selectedDevice = device;
                  _attributesInDevice = widget.allAttributes.where((att) {
                    if (_selectedDevice == null) {
                      return false;
                    } else if (_selectedDevice!.deviceTypeID != null) {
                      return att.deviceTypeID == _selectedDevice!.deviceTypeID;
                    } else {
                      return att.deviceID == _selectedDevice!.id;
                    }
                  }).toList();
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
          ConditionField(
            initialConditions: _conditions,
            attributes: _attributesInDevice,
            alertID: _alertID,
            onConditionsChanged: (conditions) {
              updateConditionsloc(context, conditions);
              setState(() {
                _conditions = conditions;
              });
            },
            enabled: widget.enabled,
          ),
          // List ranges error line
          if (dvcdFormFieldState.hasError) const SizedBox(height: 8),
          if (dvcdFormFieldState.hasError)
            Text(
              dvcdFormFieldState.errorText!,
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
