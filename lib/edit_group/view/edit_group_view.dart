import 'package:bee/components/component.dart';
import 'package:bee/edit_group/edit_group.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_repository/user_repository.dart';

class EditGroupView extends StatelessWidget {
  const EditGroupView({super.key, required this.initialGroup});

  final Group? initialGroup;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    return BlocListener<EditGroupBloc, EditGroupState>(
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
                  content: state.initialGroup == null
                      ? 'New group has been created'
                      : 'Group has been updated',
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
                          initText: initialGroup?.name,
                          labelText: 'Group Name',
                          picture: Assets.icons.tag2,
                          onChanged: (name) => context
                              .read<EditGroupBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'DESCRIPTION',
                          style: textTheme.bodySmall!
                              .copyWith(color: ColorName.neural600),
                        ),
                        const SizedBox(height: 8),
                        TTextField(
                          initText: initialGroup?.description,
                          labelText: 'Group Description',
                          picture: Assets.icons.documentText,
                          onChanged: (description) => context
                              .read<EditGroupBloc>()
                              .add(DescriptionChanged(description)),
                          validator: (value) => null,
                        ),
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
                context.read<EditGroupBloc>().add(const Submitted());
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
    final initialGroup =
        context.select((EditGroupBloc bloc) => bloc.state.initialGroup);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          initialGroup != null ?
          'EDIT GROUP' : 'NEW GROUP',
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
