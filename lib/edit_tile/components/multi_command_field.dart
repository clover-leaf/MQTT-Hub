import 'dart:convert';

import 'package:bee/components/t_add_button.dart';
import 'package:bee/components/t_circle_button.dart';
import 'package:bee/components/t_vanilla_text.dart';
import 'package:bee/edit_tile/bloc/bloc.dart';
import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/edit_tile/sheets/sheet.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class MultiCommandField extends StatefulWidget {
  const MultiCommandField(this.initialLob, {super.key});

  final String initialLob;

  @override
  State<MultiCommandField> createState() => _MultiCommandFieldState();
}

class _MultiCommandFieldState extends State<MultiCommandField> {
  late List<Command> _commands;

  @override
  void initState() {
    // decode lob
    // we will get {'commands':[{'icon':'abc','value':100,'label':'abc'}]}
    final decoded = jsonDecode(widget.initialLob) as Map<String, dynamic>;
    // get commands
    final commands = decoded['commands']! as List<dynamic>;
    // convert commands to list of Command
    _commands = commands
        .map((json) => Command.fromJson(json as Map<String, dynamic>))
        .toList();
    super.initState();
  }

  void updateBloc(BuildContext context, List<Command> commands) {
    // convert Command list to json list
    final jsonCommands = commands.map((cm) => cm.toJson()).toList();
    // create new lob
    final lob = jsonEncode({'commands': jsonCommands});
    context.read<EditTileBloc>().add(LobChanged(lob));
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _commands,
      validator: (_) {
        if (_commands.isEmpty) {
          return 'Must have at least one command';
        } else {
          final values = <String>[];
          for (final cm in _commands) {
            if (values.contains(cm.value)) {
              return 'Each command must have different value';
            } else {
              values.add(cm.value);
            }
          }
        }
        return null;
      },
      builder: (commandsFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'COMMAND LIST',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              TAddButton(
                label: 'ADD COMMAND',
                onPressed: () {
                  final icon =
                      TileHelper.svgPathToString(Assets.icons.cloud.path);
                  final command = Command(icon: icon, value: '', label: '');
                  final commands = [..._commands, command];
                  updateBloc(context, commands);
                  setState(() {
                    _commands = commands;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(_commands.length, (index) {
            final cm = _commands[index];
            final icon = TileHelper.stringToSvg(cm.icon);
            return Column(
              children: [
                _CommandItem(
                  index: index,
                  commands: _commands,
                  icon: icon,
                  value: cm.value,
                  label: cm.label,
                  onSaved: (commands) {
                    updateBloc(context, commands);
                    setState(() {
                      _commands = commands;
                    });
                  },
                ),
                const SizedBox(height: 12)
              ],
            );
          }),
          // List commands error line
          if (commandsFormFieldState.hasError)
            Text(
              commandsFormFieldState.errorText!,
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

class _CommandItem extends StatelessWidget {
  const _CommandItem({
    required this.index,
    required this.commands,
    required this.icon,
    required this.value,
    required this.label,
    required this.onSaved,
  });

  final int index;
  final List<Command> commands;
  final SvgGenImage icon;
  final String value;
  final String label;
  final void Function(List<Command>) onSaved;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async => showMaterialModalBottomSheet<SvgGenImage?>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (bContext) => IconSheet(
              initialIcon: icon,
              onIconChanged: (icon) => Navigator.of(bContext).pop(icon),
            ),
          ).then((_icon) {
            if (_icon != null) {
              if (index >= 0 && index < commands.length) {
                // get Command instance at index
                final command = commands[index];
                // convert SvgGen to string
                final iconInString = TileHelper.svgPathToString(_icon.path);
                // create new Command
                final updatedCommand = command.copyWith(icon: iconInString);
                // update Command list
                commands[index] = updatedCommand;
                onSaved(commands);
              }
            }
          }),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: ColorName.neural300,
            child: icon.svg(
              fit: BoxFit.scaleDown,
              color: ColorName.neural700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: TVanillaText(
            initText: value,
            hintText: 'Sent Value',
            onChanged: (value) {
              if (index >= 0 && index < commands.length) {
                // get Command instance at index
                final command = commands[index];
                // create new Command
                final updatedCommand = command.copyWith(value: value);
                // update Command list
                commands[index] = updatedCommand;
                onSaved(commands);
              }
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null) {
                return 'Invalid';
              }
              return null;
            },
            textInputType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: TVanillaText(
            initText: label,
            hintText: 'Label',
            onChanged: (label) {
              if (index >= 0 && index < commands.length) {
                // get Command instance at index
                final command = commands[index];
                // create new Command
                final updatedCommand = command.copyWith(label: label);
                // update Command list
                commands[index] = updatedCommand;
                onSaved(commands);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
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
            if (index >= 0 && index < commands.length) {
              // remove at index
              commands.removeAt(index);
              onSaved(commands);
            }
          },
        )
      ],
    );
  }
}
