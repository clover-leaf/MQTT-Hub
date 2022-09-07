import 'package:bee/edit_tile/bloc/edit_tile_bloc.dart';
import 'package:bee/edit_tile/data/tile_helper.dart';
import 'package:bee/edit_tile/sheets/icon_color_sheet.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class IconItem extends StatefulWidget {
  const IconItem(
      {super.key,
      required this.initialColor,
      required this.initialIcon,
      required this.enabled,});

  final Color? initialColor;
  final SvgGenImage? initialIcon;
  final bool enabled;

  @override
  State<IconItem> createState() => _IconItemState();
}

class _IconItemState extends State<IconItem> {
  late Color _color;
  late SvgGenImage _icon;
  @override
  void initState() {
    super.initState();
    _color = widget.initialColor ?? ColorName.iColor1;
    _icon = widget.initialIcon ?? Assets.icons.sun;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.enabled) {
          await showMaterialModalBottomSheet<Map<String, dynamic>?>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (bContext) => IconColorSheet(
              initialColor: _color,
              initialIcon: _icon,
              // when select device, return ID and name
              onSaved: (valueMap) => Navigator.of(bContext).pop(valueMap),
            ),
          ).then((value) {
            if (value != null) {
              final color = value['color'] as Color;
              final icon = value['icon'] as SvgGenImage;
              final colorInString = TileHelper.colorToString(color);
              final iconInString = TileHelper.svgPathToString(icon.path);
              context.read<EditTileBloc>().add(ColorChanged(colorInString));
              context.read<EditTileBloc>().add(IconChanged(iconInString));
              setState(() {
                _color = color;
                _icon = icon;
              });
            }
          });
        }
      },
      child: CircleAvatar(
        radius: 24,
        backgroundColor: _color,
        child: _icon.svg(
          color: ColorName.white,
          fit: BoxFit.scaleDown,
          height: 22,
          width: 22,
        ),
      ),
    );
  }
}
