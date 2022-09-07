import 'package:bee/components/t_circle_button.dart';
import 'package:bee/components/t_secondary_button.dart';
import 'package:bee/components/t_snackbar.dart';
import 'package:bee/components/t_text_field.dart';
import 'package:bee/edit_tile/edit_tile.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_repository/user_repository.dart';

class EditTileView extends StatelessWidget {
  const EditTileView({
    super.key,
    required this.tileType,
    required this.initialColor,
    required this.initialIcon,
    required this.initialLob,
    required this.initialName,
    required this.devices,
    required this.attributes,
    required this.initialDevice,
    required this.initialAttribute,
  });

  final TileType tileType;
  final Color? initialColor;
  final SvgGenImage? initialIcon;
  final String initialLob;
  final String? initialName;
  final List<Device> devices;
  final List<Attribute> attributes;
  final Device? initialDevice;
  final Attribute? initialAttribute;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    // get is edit
    final isEdit = context.select((EditTileBloc bloc) => bloc.state.isEdit);

    return BlocListener<EditTileBloc, EditTileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isProcessing()) {
          context.loaderOverlay.show();
        } else {
          if (state.status.isSuccess()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.success(
                  context,
                  content: state.initialTile == null
                      ? 'New tile has been created'
                      : 'Tile has been updated',
                ),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
            Navigator.of(context).pop();
          } else if (state.status.isFailure()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.error(context, content: state.error!),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          }
        }
      },
      child: GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            SizedBox(height: paddingTop),
            _Header(_formKey),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const _Title(),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ICON & NAME',
                          style: textTheme.bodySmall!
                              .copyWith(color: ColorName.neural600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: IconItem(
                                initialColor: initialColor,
                                initialIcon: initialIcon,
                                enabled: isEdit,
                              ),
                            ),
                            Expanded(
                              child: TTextField(
                                initText: initialName,
                                labelText: 'Tile Name',
                                picture: Assets.icons.tag2,
                                enabled: isEdit,
                                onChanged: (tileName) => context
                                    .read<EditTileBloc>()
                                    .add(TileNameChanged(tileName)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter a valid string';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DeviceAttributeFIeld(
                          devices: devices,
                          initialDevice: initialDevice,
                          initialAttribute: initialAttribute,
                          enabled: isEdit,
                        ),
                        const SizedBox(height: 24),
                        if (tileType.isLinearGauge || tileType.isRadialGauge)
                          GaugeTileField(initialLob, enabled: isEdit)
                        else if (tileType.isLine || tileType.isBar)
                          LineField(initialLob, enabled: isEdit)
                        else if (tileType.isToggle)
                          ToggleTileField(initialLob)
                        else if (tileType.isMultiCommand)
                          MultiCommandField(initialLob)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.formKey);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // get is edit
    final isEdit = context.select((EditTileBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((EditTileBloc bloc) => bloc.state.isAdmin);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TCircleButton(
          picture: Assets.icons.arrowLeft
              .svg(color: ColorName.neural700, fit: BoxFit.scaleDown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (isAdmin)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: isEdit
                ? TSecondaryButton(
                    label: 'SAVE',
                    onPressed: () {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        context.read<EditTileBloc>().add(const Submitted());
                      }
                    },
                    enabled: true,
                    textStyle: textTheme.labelLarge!.copyWith(
                      color: ColorName.sky500,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  )
                : TSecondaryButton(
                    label: 'EDIT',
                    onPressed: () {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        context
                            .read<EditTileBloc>()
                            .add(const IsEditChanged(isEdit: true));
                      }
                    },
                    enabled: true,
                    textStyle: textTheme.labelLarge!.copyWith(
                      color: ColorName.sky500,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
          )
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final type = context.select((EditTileBloc bloc) => bloc.state.type);
    final typeTitle = type.getTitle();
    final description = type.getDescription();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$typeTitle Tile'.toUpperCase(),
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorName.neural600,
          ),
        ),
      ],
    );
  }
}
