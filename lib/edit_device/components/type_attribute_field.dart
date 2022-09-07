import 'package:bee/components/component.dart';
import 'package:bee/edit_device/bloc/bloc.dart';
import 'package:bee/edit_device/components/attribute_field.dart';
import 'package:bee/edit_device/sheets/device_type_sheet.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class TypeAttributeField extends StatefulWidget {
  const TypeAttributeField({
    super.key,
    required this.initialDeviceType,
    required this.initialAttributes,
    required this.allAttributes,
    required this.deviceID,
    required this.isUseDeviceType,
    required this.enabled,
  });

  final DeviceType? initialDeviceType;
  final List<Attribute> initialAttributes;
  final List<Attribute> allAttributes;
  final String deviceID;
  final bool isUseDeviceType;
  final bool enabled;

  @override
  State<TypeAttributeField> createState() => _TypeAttributeFieldState();
}

class _TypeAttributeFieldState extends State<TypeAttributeField> {
  late List<Attribute> _attributes;
  late DeviceType? _deviceType;
  late bool _isUseDeviceType;

  @override
  void initState() {
    _deviceType = widget.initialDeviceType;
    if (_deviceType != null) {
      final attOfType = widget.allAttributes
          .where((att) => att.deviceTypeID == _deviceType!.id)
          .toList();
      _attributes = attOfType;
    } else {
      _attributes = widget.initialAttributes;
    }
    _isUseDeviceType = widget.isUseDeviceType;
    super.initState();
  }

  void updateBloc(BuildContext context, List<Attribute> attributes) {
    context.read<EditDeviceBloc>().add(AttributesChanged(attributes));
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _attributes,
      validator: (_) => null,
      builder: (typeAttributeFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'USE DEVICE TYPE',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              IgnorePointer(
                ignoring: !widget.enabled,
                child: Switch(
                  value: _isUseDeviceType,
                  activeColor: ColorName.sky500,
                  onChanged: (value) {
                    if (value) {
                      if (_deviceType != null) {
                        context.read<EditDeviceBloc>().add(
                              SelectedDeviceTypeIDChanged(
                                  () => _deviceType!.id,),
                            );
                        final attOfType = widget.allAttributes
                            .where((att) => att.deviceTypeID == _deviceType!.id)
                            .toList();
                        context
                            .read<EditDeviceBloc>()
                            .add(AttributesChanged(attOfType));
                        setState(() {
                          _attributes = attOfType;
                        });
                      }
                      setState(() {
                        _isUseDeviceType = value;
                      });
                    } else {
                      context
                          .read<EditDeviceBloc>()
                          .add(SelectedDeviceTypeIDChanged(() => null));
                      context
                          .read<EditDeviceBloc>()
                          .add(const AttributesChanged([]));
                      setState(() {
                        _isUseDeviceType = value;
                        _attributes = [];
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TSelectedField(
            labelText: 'Device Type',
            initialValue: widget.initialDeviceType?.name,
            picture: Assets.icons.airdrop,
            enabled: widget.enabled && _isUseDeviceType,
            onTapped: () async => showMaterialModalBottomSheet<DeviceType?>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (bContext) => BlocProvider.value(
                value: BlocProvider.of<EditDeviceBloc>(context),
                child: DeviceTypeSheet(
                  // when select deviceType, return deviceType
                  onDeviceTypeSelect: (deviceType) =>
                      Navigator.of(bContext).pop(deviceType),
                ),
              ),
            ).then((deviceType) {
              if (deviceType != null) {
                context
                    .read<EditDeviceBloc>()
                    .add(SelectedDeviceTypeIDChanged(() => deviceType.id));
                final attOfType = widget.allAttributes
                    .where((att) => att.deviceTypeID == deviceType.id)
                    .toList();
                setState(() {
                  _deviceType = deviceType;
                  _attributes = attOfType;
                });
                return deviceType.name;
              }
              return null;
            }),
            validator: (value) {
              if (_isUseDeviceType && (value == null || value.isEmpty)) {
                return 'Device type must not be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          AttributeField(
            initialAttributes: _attributes,
            deviceID: widget.deviceID,
            enabled: widget.enabled && !_isUseDeviceType,
          ),
          // List ranges error line
          if (typeAttributeFormFieldState.hasError)
            Text(
              typeAttributeFormFieldState.errorText!,
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
