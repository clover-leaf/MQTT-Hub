import 'package:bee/components/component.dart';
import 'package:bee/edit_device/components/attribute_field.dart';
import 'package:bee/edit_device/edit_device.dart';
import 'package:bee/edit_device/sheets/broker_sheet.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class EditDeviceView extends StatelessWidget {
  const EditDeviceView({
    super.key,
    required this.initialID,
    required this.initialDevice,
    required this.initialSelectedBroker,
    required this.initialAttributes,
  });

  final String initialID;
  final Device? initialDevice;
  final Broker? initialSelectedBroker;
  final List<Attribute> initialAttributes;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<EditDeviceBloc, EditDeviceState>(
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
                  content: state.initialDevice == null
                      ? 'New device has been created'
                      : 'Device has been updated',
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
                          'NAME',
                          style: textTheme.bodySmall!
                              .copyWith(color: ColorName.neural600),
                        ),
                        const SizedBox(height: 8),
                        TTextField(
                          initText: initialDevice?.name,
                          labelText: 'Device Name',
                          picture: Assets.icons.tag2,
                          onChanged: (name) => context
                              .read<EditDeviceBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TSelectedField(
                          labelText: 'Broker',
                          initialValue: initialSelectedBroker?.name,
                          picture: Assets.icons.airdrop,
                          onTapped: () async =>
                              showMaterialModalBottomSheet<Broker?>(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (bContext) => BlocProvider.value(
                              value: BlocProvider.of<EditDeviceBloc>(context),
                              child: BrokerSheet(
                                // when select broker, return broker
                                onBrokerSelected: (broker) =>
                                    Navigator.of(bContext).pop(broker),
                              ),
                            ),
                          ).then((broker) {
                            if (broker != null) {
                              context
                                  .read<EditDeviceBloc>()
                                  .add(SelectedBrokerIDChanged(broker.id));
                              return broker.name;
                            }
                            return null;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Broker must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'TOPIC',
                          style: textTheme.bodySmall!
                              .copyWith(color: ColorName.neural600),
                        ),
                        const SizedBox(height: 8),
                        TTextField(
                          initText: initialDevice?.topic,
                          labelText: 'Device Topic',
                          picture: Assets.icons.tag2,
                          onChanged: (topic) => context
                              .read<EditDeviceBloc>()
                              .add(TopicChanged(topic)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AttributeField(
                          initialAttributes: initialAttributes,
                          deviceID: initialID,
                        )
                      ],
                    ),
                  )
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TCircleButton(
          picture: Assets.icons.arrowLeft
              .svg(color: ColorName.neural700, fit: BoxFit.scaleDown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TSecondaryButton(
            label: 'SAVE',
            onPressed: () {
              if (formKey.currentState != null &&
                  formKey.currentState!.validate()) {
                context.read<EditDeviceBloc>().add(const Submitted());
              }
            },
            enabled: true,
            textStyle: textTheme.labelLarge!.copyWith(
              color: ColorName.sky500,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device'.toUpperCase(),
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
