import 'dart:convert';

import 'package:bee/components/t_vanilla_text.dart';
import 'package:bee/edit_tile/bloc/bloc.dart';
import 'package:bee/edit_tile/data/data.dart';
import 'package:bee/edit_tile/sheets/color_sheet.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class ToggleTileField extends StatefulWidget {
  const ToggleTileField(this.initialLob, {super.key});

  final String initialLob;

  @override
  State<ToggleTileField> createState() => _ToggleTileFieldState();
}

class _ToggleTileFieldState extends State<ToggleTileField> {
  late ToggleConfig _left;
  late ToggleConfig _right;

  @override
  void initState() {
    // decode lob
    // we will get {'left':[{'value':'12','label':'on','color':'#123456'}]}
    final decoded = jsonDecode(widget.initialLob) as Map<String, dynamic>;
    // get ranges
    final left = decoded['left']! as Map<String, dynamic>;
    final right = decoded['right']! as Map<String, dynamic>;
    // convert them to left, right config
    _left = ToggleConfig.fromJson(left);
    _right = ToggleConfig.fromJson(right);
    if (_left.color.isEmpty) {
      _left =
          _left.copyWith(color: TileHelper.colorToString(ColorName.iColor1));
    }
    if (_right.color.isEmpty) {
      _right =
          _right.copyWith(color: TileHelper.colorToString(ColorName.iColor1));
    }
    super.initState();
  }

  void updateBloc(BuildContext context, ToggleConfig left, ToggleConfig right) {
    // convert ToggleConfig to json
    final jsonLeft = left.toJson();
    final jsonRight = right.toJson();
    // create new lob
    final lob = jsonEncode({'left': jsonLeft, 'right': jsonRight});
    context.read<EditTileBloc>().add(LobChanged(lob));
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: [_left, _right],
      validator: (_) {
        // we check left and right value is valid or not in their field
        if (_left.value.isEmpty || _right.value.isEmpty) {
          return null;
        }
        // check if left and right have the same value
        if (_left.value == _right.value) {
          return 'States must have different value';
        }
        // check if left and right have the same color
        if (_left.color == _right.color) {
          return 'States must have different color';
        }
        return null;
      },
      builder: (rangesFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATES LIST',
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural600),
          ),
          const SizedBox(height: 12),
          _ToggleConfigItem(
            config: _left,
            onSaved: (config) {
              updateBloc(context, config, _right);
              setState(() {
                _left = config;
              });
            },
          ),
          const SizedBox(height: 12),
          _ToggleConfigItem(
            config: _right,
            onSaved: (config) {
              updateBloc(context, _left, config);
              setState(() {
                _right = config;
              });
            },
          ),
          // List ranges error line
          if (rangesFormFieldState.hasError) const SizedBox(height: 8),
          if (rangesFormFieldState.hasError)
            Text(
              rangesFormFieldState.errorText!,
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

class _ToggleConfigItem extends StatelessWidget {
  const _ToggleConfigItem({
    required this.config,
    required this.onSaved,
  });

  final ToggleConfig config;
  final void Function(ToggleConfig) onSaved;

  @override
  Widget build(BuildContext context) {
    final color = config.color.isNotEmpty
        ? TileHelper.stringToColor(config.color)
        : ColorName.iColor1;
    final value = config.value.isNotEmpty ? config.value : null;
    final label = config.label;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async => showMaterialModalBottomSheet<Color?>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (bContext) => ColorSheet(
              initialColor: color,
              onColorChanged: (color) => Navigator.of(bContext).pop(color),
            ),
          ).then((color) {
            if (color != null) {
              // convert selected color to String
              final colorInString = TileHelper.colorToString(color);
              // create new GaugeRange with coverted color
              onSaved(config.copyWith(color: colorInString));
            }
          }),
          child: CircleAvatar(radius: 24, backgroundColor: color),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: TVanillaText(
            initText: value,
            hintText: 'State Value',
            onChanged: (value) => onSaved(config.copyWith(value: value)),
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
            hintText: 'State Label',
            onChanged: (value) => onSaved(config.copyWith(label: value)),
            validator: (value) {
              if (value != null && value.length > 3) {
                return 'Max length is 3';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
