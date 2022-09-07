import 'package:bee/components/component.dart';
import 'package:bee/edit_dashboard/edit_dashboard.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditDashboardView extends StatelessWidget {
  const EditDashboardView({super.key, required this.initialName});

  final String? initialName;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    // get is edit
    final isEdit =
        context.select((EditDashboardBloc bloc) => bloc.state.isEdit);

    return BlocListener<EditDashboardBloc, EditDashboardState>(
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
                  content: state.initialDashboard == null
                      ? 'New dashboard has been created'
                      : 'Dashboard has been updated',
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
                          initText: initialName,
                          labelText: 'Dashboard Name',
                          picture: Assets.icons.tag2,
                          onChanged: (name) => context
                              .read<EditDashboardBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                          enabled: isEdit,
                        ),
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

    final isEdit =
        context.select((EditDashboardBloc bloc) => bloc.state.isEdit);
    final isAdmin =
        context.select((EditDashboardBloc bloc) => bloc.state.isAdmin);

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
                        context
                            .read<EditDashboardBloc>()
                            .add(const Submitted());
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
                        .read<EditDashboardBloc>()
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
    final initialDashboard =
        context.select((EditDashboardBloc bloc) => bloc.state.initialDashboard);
    // get is edit
    final isEdit =
        context.select((EditDashboardBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          initialDashboard == null
              ? 'NEW DASHBOARD'
              : isEdit
                  ? 'EDIT DASHBOARD'
                  : 'DASHBOARD DETAIL',
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
