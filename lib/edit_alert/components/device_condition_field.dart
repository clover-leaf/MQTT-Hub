import 'package:bee/components/t_selected_box.dart';
import 'package:bee/edit_alert/edit_alert.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class DeviceConditionField extends StatefulWidget {
  const DeviceConditionField({
    super.key,
    required this.alertID,
    required this.attributes,
    required this.initialDevice,
    required this.initialConditions,
  });

  final String alertID;
  final List<Attribute> attributes;
  final Device? initialDevice;
  final List<Condition> initialConditions;

  @override
  State<DeviceConditionField> createState() => _DeviceConditionFieldState();
}

class _DeviceConditionFieldState extends State<DeviceConditionField> {
  late final String _alertID;
  late Device? _selectedDevice;
  late List<Condition> _conditions;
  late List<Attribute> _attributesInDevice;

  @override
  void initState() {
    _alertID = widget.alertID;
    _selectedDevice = widget.initialDevice;
    _conditions = widget.initialConditions;
    _attributesInDevice = widget.attributes
        .where((att) => att.deviceID == _selectedDevice?.id)
        .toList();
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
    return FormField(
      initialValue: [_selectedDevice, _conditions],
      validator: (_) => null,
      builder: (dvattFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TSelectedField(
            labelText: 'Device',
            initialValue: _selectedDevice?.name,
            picture: Assets.icons.airdrop,
            onTapped: () async => showMaterialModalBottomSheet<Device?>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (bContext) => BlocProvider.value(
                value: BlocProvider.of<EditAlertBloc>(context),
                child: DeviceSheet(
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
                  _attributesInDevice = widget.attributes
                      .where((att) => att.deviceID == device.id)
                      .toList();
                  _conditions = [];
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
          )
        ],
      ),
    );
  }
}
