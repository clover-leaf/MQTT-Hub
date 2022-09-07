import 'package:bee/components/component.dart';
import 'package:bee/edit_schedule/edit_schedule.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_repository/user_repository.dart';

class EditScheduleView extends StatelessWidget {
  const EditScheduleView({
    super.key,
    required this.initialID,
    required this.initialSchedule,
    required this.attributes,
    required this.devices,
    required this.initialActions,
    required this.initialDayOfWeeks,
  });

  final String initialID;
  final Schedule? initialSchedule;
  final List<Attribute> attributes;
  final List<Device> devices;
  final List<TAction> initialActions;
  final List<int> initialDayOfWeeks;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    // get is edit
    final isEdit = context.select((EditScheduleBloc bloc) => bloc.state.isEdit);

    return BlocListener<EditScheduleBloc, EditScheduleState>(
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
                  content: state.initialSchedule == null
                      ? 'New schedule has been created'
                      : 'Schedule has been updated',
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'NAME',
                            style: textTheme.bodySmall!
                                .copyWith(color: ColorName.neural600),
                          ),
                        ),
                        TTextField(
                          initText: initialSchedule?.name,
                          labelText: 'Schedule Name',
                          picture: Assets.icons.tag2,
                          onChanged: (name) => context
                              .read<EditScheduleBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                          enabled: isEdit,
                        ),
                        const SizedBox(height: 16),
                        TimeField(
                          initialTime: initialSchedule != null
                              ? TimeOfDay(
                                  hour: initialSchedule!.time.hour,
                                  minute: initialSchedule!.time.minute,
                                )
                              : const TimeOfDay(hour: 0, minute: 0),
                          enabled: isEdit,
                        ),
                        const SizedBox(height: 24),
                        DateField(
                          initialDate: initialSchedule?.date ?? DateTime.now(),
                          isRepeat: initialSchedule?.isRepeat ?? false,
                          dayOfWeeks: initialDayOfWeeks,
                          enabled: isEdit,
                        ),
                        const SizedBox(height: 24),
                        ActionListField(
                          scheduleID: initialID,
                          initialActions: initialActions,
                          devices: devices,
                          attributes: attributes,
                          enabled: isEdit,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
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

    final isEdit = context.select((EditScheduleBloc bloc) => bloc.state.isEdit);
    final isAdmin =
        context.select((EditScheduleBloc bloc) => bloc.state.isAdmin);

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
                        context.read<EditScheduleBloc>().add(const Submitted());
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
                    onPressed: () => context
                        .read<EditScheduleBloc>()
                        .add(const IsEditChanged(isEdit: true)),
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
    final initialSchedule =
        context.select((EditScheduleBloc bloc) => bloc.state.initialSchedule);
    final isEdit =
        context.select((EditScheduleBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          initialSchedule == null
              ? 'NEW SCHEDULE'
              : isEdit
                  ? 'EDIT SCHEDULE'
                  : 'SCHEDULE DETAIL',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
      ],
    );
  }
}
