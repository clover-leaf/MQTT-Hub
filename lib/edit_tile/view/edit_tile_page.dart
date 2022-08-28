import 'package:bee/edit_tile/edit_tile.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class EditTilePage extends StatelessWidget {
  const EditTilePage({
    super.key,
    required this.tileType,
    required this.devices,
    required this.attributes,
    required this.initialDevice,
    required this.initialAttribute,
    required this.initialTile,
  });

  final TileType tileType;
  final List<Device> devices;
  final List<Attribute> attributes;
  final Device? initialDevice;
  final Attribute? initialAttribute;
  final Tile? initialTile;

  static PageRoute<void> route({
    required FieldId dashboardID,
    required TileType type,
    required List<Device> devices,
    required List<Attribute> attributes,
    required Tile? initialTile,
  }) {
    final deviceView = {for (final dv in devices) dv.id: dv};
    final selectedDevice = deviceView[initialTile?.deviceID];
    final attributeView = {for (final att in attributes) att.id: att};
    final selectedAttribute = attributeView[initialTile?.attributeID];
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => EditTileBloc(
          context.read<UserRepository>(),
          dashboardID: dashboardID,
          devices: devices,
          attributes: attributes,
          type: type,
          initialTile: initialTile,
        ),
        child: EditTilePage(
          tileType: type,
          devices: devices,
          attributes: attributes,
          initialDevice: selectedDevice,
          initialAttribute: selectedAttribute,
          initialTile: initialTile,
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.white,
      body: EditTileView(
        tileType: tileType,
        initialLob: initialTile?.lob ?? tileType.getInitialLob(),
        initialColor: initialTile != null
            ? TileHelper.stringToColor(initialTile!.color)
            : null,
        initialIcon: initialTile != null
            ? TileHelper.stringToSvg(initialTile!.icon)
            : null,
        initialName: initialTile?.name,
        devices: devices,
        attributes: attributes,
        initialDevice: initialDevice,
        initialAttribute: initialAttribute,
      ),
    );
  }
}
