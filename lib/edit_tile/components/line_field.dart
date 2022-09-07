import 'dart:convert';

import 'package:bee/edit_tile/edit_tile.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LineField extends StatelessWidget {
  const LineField(this.initialLob, {super.key, required this.enabled});

  final String initialLob;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'LINE COLOR',
            style: textTheme.bodySmall!.copyWith(color: ColorName.neural600),
          ),
        ),
        _ColorItem(initialLob, enabled: enabled)
      ],
    );
  }
}

class _ColorItem extends StatefulWidget {
  const _ColorItem(this.initialLob, {required this.enabled});

  final String initialLob;
  final bool enabled;

  @override
  State<_ColorItem> createState() => _ColorItemState();
}

class _ColorItemState extends State<_ColorItem> {
  late Color _color;

  @override
  void initState() {
    final decoded = jsonDecode(widget.initialLob) as Map<String, dynamic>;
    final color = decoded['color'] as String;
    if (color.isNotEmpty) {
      _color = TileHelper.stringToColor(color);
    } else {
      _color = ColorName.iColor1;
    }
    super.initState();
  }

  void updateBloc(BuildContext context, Color color) {
    // create new lob
    final colorInString = TileHelper.colorToString(color);
    final lob = jsonEncode({'color': colorInString});
    context.read<EditTileBloc>().add(LobChanged(lob));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.enabled) {
          await showMaterialModalBottomSheet<Color?>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (bContext) => ColorSheet(
              initialColor: _color,
              onColorChanged: (color) => Navigator.of(bContext).pop(color),
            ),
          ).then((color) {
            if (color != null) {
              updateBloc(context, color);
              setState(() {
                _color = color;
              });
            }
          });
        }
      },
      child: CircleAvatar(
        radius: 24,
        backgroundColor: _color,
      ),
    );
  }
}
