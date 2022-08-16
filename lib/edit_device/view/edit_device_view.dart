import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bee/edit_broker/edit_broker.dart';
import 'package:bee/edit_device/edit_device.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class EditDeviceView extends StatelessWidget {
  const EditDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (EditDeviceBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<EditDeviceBloc, EditDeviceState>(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'On Snap!',
                      message: state.error!,
                      contentType: ContentType.failure,
                    ),
                  ),
                );
            }
          },
        ),
        BlocListener<EditDeviceBloc, EditDeviceState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Congratulations!',
                      message: state.initDevice == null
                          ? 'New device has been created'
                          : 'Device has been updated',
                      contentType: ContentType.success,
                    ),
                  ),
                );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 32,
        ),
        children: [
          const _Header(),
          _NameInput(
            label: 'Device Name',
            hintText: 'Your Device Name',
            isInProgress: isInProgress,
            onChanged: (deviceName) => context
                .read<EditDeviceBloc>()
                .add(EditDeviceNameChanged(deviceName)),
          ),
          const _BrokerInput(),
          _NameInput(
            label: 'Device Topic',
            hintText: 'Your Device Topic',
            isInProgress: isInProgress,
            onChanged: (deviceTopic) => context
                .read<EditDeviceBloc>()
                .add(EditTopicNameChanged(deviceTopic)),
          ),
          const _AttributeInput()
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<EditDeviceBloc>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.initDevice == null ? 'New Device' : 'Edit Device',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            state.path,
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttributeInput extends StatelessWidget {
  const _AttributeInput();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedAttributes =
        context.select((EditDeviceBloc bloc) => bloc.state.selectedAttributes);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attributes',
                  style: textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: ColorName.blue,
                    onPrimary: ColorName.darkBlue,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet<void Function()>(
                      isScrollControlled: true,
                      context: context,
                      builder: (bContext) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            32,
                            16,
                            32,
                            MediaQuery.of(bContext).viewInsets.bottom + 32,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _NameInput(
                                label: 'Attribute Name',
                                hintText: 'Device Atribute Name',
                                isInProgress: false,
                                onChanged: (attributeName) =>
                                    context.read<EditDeviceBloc>().add(
                                          EditTempAttributeNameChanged(
                                            attributeName,
                                          ),
                                        ),
                              ),
                              _NameInput(
                                label: 'Attribute Json Path',
                                hintText: 'Device Atributte Json Path',
                                isInProgress: false,
                                onChanged: (attributeJsonPath) =>
                                    context.read<EditDeviceBloc>().add(
                                          EditTempAttributeJsonPathChanged(
                                            attributeJsonPath,
                                          ),
                                        ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  elevation: 0,
                                  primary: ColorName.blue,
                                  onPrimary: ColorName.darkBlue,
                                  shadowColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                onPressed: () => Navigator.of(bContext).pop(
                                  () => context
                                      .read<EditDeviceBloc>()
                                      .add(const EditTempAttributeSaved()),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create attribute',
                                      style: textTheme.labelLarge!
                                          .copyWith(color: ColorName.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ).then((callback) {
                      if (callback != null) {
                        callback.call();
                      }
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.icons.add.svg(color: ColorName.white),
                        Text(
                          'New Attribute',
                          style: textTheme.labelMedium!
                              .copyWith(color: ColorName.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...selectedAttributes.map(_AttributeItem.new).toList()
        ],
      ),
    );
  }
}

class _AttributeItem extends StatelessWidget {
  const _AttributeItem(this.attribute);

  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attribute.name,
              style: textTheme.titleMedium,
            ),
            Text(
              attribute.jsonPath,
              style: textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    required this.label,
    required this.hintText,
    required this.isInProgress,
    required this.onChanged,
  });

  final String label;
  final String hintText;
  final bool isInProgress;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              label,
              style: textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextFormField(
            readOnly: isInProgress,
            style: textTheme.labelLarge,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme.labelLarge!.copyWith(
                color: ColorName.blueGray,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorName.gray),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorName.blueGray),
                borderRadius: BorderRadius.circular(4),
              ),
              prefixIcon: Assets.icons.box2.svg(
                color: ColorName.blueGray,
                fit: BoxFit.scaleDown,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _BrokerInput extends StatelessWidget {
  const _BrokerInput();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isInProgress = context.select(
      (EditDeviceBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );
    final showedBrokers =
        context.select((EditDeviceBloc bloc) => bloc.state.showedBrokers);
    final selectedBroker =
        context.select((EditDeviceBloc bloc) => bloc.state.selectedBroker);
    final rootProject =
        context.select((EditDeviceBloc bloc) => bloc.state.rootProject);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Broker',
                  style: textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: ColorName.blue,
                    onPrimary: ColorName.darkBlue,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    EditBrokerPage.route(
                      project: rootProject,
                      initBroker: null,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.icons.add.svg(color: ColorName.white),
                        Text(
                          'New Broker',
                          style: textTheme.labelMedium!
                              .copyWith(color: ColorName.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!isInProgress) {
                await showMaterialModalBottomSheet<void Function()>(
                  context: context,
                  builder: (bContext) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showedBrokers.isEmpty)
                        SizedBox(
                          height: 96,
                          child: Text(
                            'There is no broker in this project',
                            style: textTheme.titleSmall,
                          ),
                        )
                      else
                        ...showedBrokers.map(
                          (br) => _BrokerItem(
                            broker: br,
                            onPress: () => Navigator.of(bContext).pop(
                              () => context
                                  .read<EditDeviceBloc>()
                                  .add(EditSelectedBrokerIDChanged(br.id)),
                            ),
                          ),
                        )
                    ],
                  ),
                ).then((callback) {
                  if (callback != null) {
                    callback.call();
                  }
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: ColorName.gray),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Assets.icons.box2.svg(
                      color: ColorName.blueGray,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedBroker?.name ?? 'Choose broker for this device',
                        style: textTheme.labelLarge,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrokerItem extends StatelessWidget {
  const _BrokerItem({required this.broker, required this.onPress});

  final Broker broker;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPress,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              broker.name,
              style: textTheme.titleMedium,
            ),
            Text(
              broker.url,
              style: textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
