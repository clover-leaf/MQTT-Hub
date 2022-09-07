import 'package:bee/components/component.dart';
import 'package:bee/edit_schedule/edit_schedule.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class ActionListField extends StatefulWidget {
  const ActionListField({
    super.key,
    required this.scheduleID,
    required this.initialActions,
    required this.devices,
    required this.attributes,
    required this.enabled,
  });

  final String scheduleID;
  final List<TAction> initialActions;
  final List<Device> devices;
  final List<Attribute> attributes;
  final bool enabled;

  @override
  State<ActionListField> createState() => _ActionListFieldState();
}

class _ActionListFieldState extends State<ActionListField> {
  late List<TAction> _actions;
  late Map<String, Attribute> _attributeView;
  late Map<String, Device> _deviceView;

  @override
  void initState() {
    _actions = widget.initialActions;
    _deviceView = {for (final dv in widget.devices) dv.id: dv};
    _attributeView = {for (final att in widget.attributes) att.id: att};
    super.initState();
  }

  void updateBloc(BuildContext context, List<TAction> actions) {
    context.read<EditScheduleBloc>().add(ActionsChanged(actions));
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _actions,
      validator: (_) {
        if (_actions.isEmpty) {
          return 'Schedule must have at least 1 action';
        }
        return null;
      },
      builder: (actionListFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTION LIST',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              TAddButton(
                label: 'ADD ACTION',
                onPressed: () {
                  if (widget.enabled) {
                    final ac = TAction(
                      id: const Uuid().v4(),
                      alertID: null,
                      scheduleID: widget.scheduleID,
                      deviceID: '',
                      attributeID: '',
                      value: '',
                    );
                    final actions = [..._actions, ac];
                    updateBloc(context, actions);
                    setState(() {
                      _actions = actions;
                    });
                  }
                },
              )
            ],
          ),
          Text(
            'Action will be sent to device when alert is actived',
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural500),
          ),
          const SizedBox(height: 8),
          ...List.generate(_actions.length, (index) {
            final ac = _actions[index];
            final device = _deviceView[ac.deviceID];
            final attribute = _attributeView[ac.attributeID];
            return Column(
              children: [
                ActionField(
                  key: ValueKey(ac.id),
                  index: index,
                  devices: widget.devices,
                  attributes: widget.attributes,
                  actions: _actions,
                  device: device,
                  attribute: attribute,
                  value: ac.value,
                  enabled: widget.enabled,
                  onSaved: (actions) {
                    updateBloc(context, actions);
                    setState(() {
                      _actions = actions;
                    });
                  },
                ),
                const SizedBox(height: 12)
              ],
            );
          }),
          // List ranges error line
          if (actionListFormFieldState.hasError) const SizedBox(height: 8),
          if (actionListFormFieldState.hasError)
            Text(
              actionListFormFieldState.errorText!,
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

class ActionField extends StatefulWidget {
  const ActionField({
    super.key,
    required this.index,
    required this.actions,
    required this.attributes,
    required this.devices,
    required this.device,
    required this.attribute,
    required this.value,
    required this.onSaved,
    required this.enabled,
  });

  final int index;
  final List<TAction> actions;
  final List<Device> devices;
  final List<Attribute> attributes;
  final Device? device;
  final Attribute? attribute;
  final String value;
  final void Function(List<TAction>) onSaved;
  final bool enabled;

  @override
  State<ActionField> createState() => ActionFieldState();
}

class ActionFieldState extends State<ActionField> {
  late Device? _device;
  late Attribute? _attribute;
  late List<TAction> _actions;

  @override
  void initState() {
    _device = widget.device;
    _attribute = widget.attribute;
    _actions = widget.actions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.actions[widget.index].id;
    final textTheme = Theme.of(context).textTheme;
    return FormField(
      initialValue: _actions,
      validator: (_) {
        if (_device == null) {
          return 'Device must not be empty';
        } else if (_attribute == null) {
          return 'Attribute must not be empty';
        } else if (_device!.deviceTypeID != null) {
          if (_attribute!.deviceTypeID != _device!.deviceTypeID) {
            return 'Device does not contain this attribute';
          }
        } else if (_attribute!.deviceID != _device!.id) {
          return 'Device does not contain this attribute';
        }
        return null;
      },
      builder: (actionFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TSelectedVanilla(
                  key: ValueKey(id),
                  initialValue: _device?.name,
                  enabled: widget.enabled,
                  onTapped: () async => showMaterialModalBottomSheet<Device?>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (bContext) => DeviceSheet(
                      selectedDeviceID: _device?.id,
                      devices: widget.devices,
                      // when select device, return device
                      onDeviceSelected: (device) =>
                          Navigator.of(bContext).pop(device),
                    ),
                  ).then((device) {
                    if (device != null) {
                      if (widget.index >= 0 &&
                          widget.index < widget.actions.length) {
                        final ac = widget.actions[widget.index];
                        final updatedAc = ac.copyWith(deviceID: device.id);
                        final actions = List<TAction>.from(_actions);
                        actions[widget.index] = updatedAc;
                        widget.onSaved(actions);
                        setState(() {
                          _device = device;
                          _actions = actions;
                        });
                      }
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
              ),
              const SizedBox(width: 12),
              Flexible(
                child: TSelectedVanilla(
                  key: ValueKey(id),
                  initialValue: _attribute?.name,
                  enabled: widget.enabled,
                  onTapped: () async =>
                      showMaterialModalBottomSheet<Attribute?>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (bContext) {
                      final attOfDevice = widget.attributes.where((att) {
                        if (_device == null) {
                          return false;
                        } else if (_device!.deviceTypeID != null) {
                          return att.deviceTypeID == _device!.deviceTypeID;
                        } else {
                          return att.deviceID == _device!.id;
                        }
                      }).toList();
                      return AttributeSheet(
                        // when select attribute, return attribute
                        onAttributeSeleted: (attribute) =>
                            Navigator.of(bContext).pop(attribute),
                        attributes: attOfDevice,
                        selectedAttributeID: _attribute?.id,
                      );
                    },
                  ).then((attribute) {
                    if (attribute != null) {
                      if (widget.index >= 0 &&
                          widget.index < widget.actions.length) {
                        final ac = widget.actions[widget.index];
                        final updatedAc =
                            ac.copyWith(attributeID: attribute.id);
                        final actions = List<TAction>.from(_actions);
                        actions[widget.index] = updatedAc;
                        widget.onSaved(actions);
                        setState(() {
                          _attribute = attribute;
                          _actions = actions;
                        });
                      }
                      return attribute.name;
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
              ),
              const SizedBox(width: 12),
              Flexible(
                child: TVanillaText(
                  key: ValueKey(id),
                  enabled: widget.enabled,
                  initText: widget.value,
                  hintText: 'Value',
                  onChanged: (value) {
                    if (widget.index >= 0 &&
                        widget.index < widget.actions.length) {
                      final ac = widget.actions[widget.index];
                      final updatedAc = ac.copyWith(value: value);
                      final actions = List<TAction>.from(_actions);
                      actions[widget.index] = updatedAc;
                      widget.onSaved(actions);
                      setState(() {
                        _actions = actions;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
              TCircleButton(
                picture: Assets.icons.trash
                    .svg(color: ColorName.neural600, fit: BoxFit.scaleDown),
                onPressed: () {
                  if (widget.enabled) {
                    if (widget.index >= 0 &&
                        widget.index < widget.actions.length) {
                      widget.actions.removeAt(widget.index);
                      widget.onSaved(widget.actions);
                    }
                  }
                },
              )
            ],
          ),

          // List ranges error line
          if (actionFormFieldState.hasError) const SizedBox(height: 8),
          if (actionFormFieldState.hasError)
            Text(
              actionFormFieldState.errorText!,
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
