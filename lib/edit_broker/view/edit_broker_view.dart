import 'package:bee/components/component.dart';
import 'package:bee/edit_broker/edit_broker.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_repository/user_repository.dart';

class EditBrokerView extends StatelessWidget {
  const EditBrokerView({
    super.key,
    required this.initialName,
    required this.initialUrl,
    required this.initialPort,
    required this.initialAccount,
    required this.initialPassword,
    required this.initialBroker,
  });

  final String? initialName;
  final String? initialUrl;
  final String? initialPort;
  final String? initialAccount;
  final String? initialPassword;
  final Broker? initialBroker;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    // get is edit
    final isEdit = context.select((EditBrokerBloc bloc) => bloc.state.isEdit);

    return BlocListener<EditBrokerBloc, EditBrokerState>(
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
                  content: state.initialBroker == null
                      ? 'New broker has been created'
                      : 'Broker has been updated',
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
                          labelText: 'Broker Name',
                          picture: Assets.icons.tag2,
                          onChanged: (name) => context
                              .read<EditBrokerBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                          textInputType: TextInputType.url,
                          enabled: isEdit,
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'URL & PORT',
                            style: textTheme.bodySmall!
                                .copyWith(color: ColorName.neural600),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, BoxConstraints constraints) {
                            final width = constraints.maxWidth;
                            return Row(
                              children: [
                                SizedBox(
                                  width: width * 0.67,
                                  child: TTextField(
                                    initText: initialUrl,
                                    labelText: 'Broker URL',
                                    picture: Assets.icons.global,
                                    onChanged: (url) => context
                                        .read<EditBrokerBloc>()
                                        .add(UrlChanged(url)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a valid string';
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.url,
                                    enabled: isEdit,
                                  ),
                                ),
                                SizedBox(width: width * 0.03),
                                SizedBox(
                                  width: width * 0.3,
                                  child: TVanillaText(
                                    initText: initialPort,
                                    hintText: 'Port',
                                    onChanged: (port) => context
                                        .read<EditBrokerBloc>()
                                        .add(PortChanged(port)),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          int.tryParse(value) == null) {
                                        return 'Invalid';
                                      }
                                      return null;
                                    },
                                    enabled: isEdit,
                                    textInputType: TextInputType.number,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'ACOUNT (optional)',
                            style: textTheme.bodySmall!
                                .copyWith(color: ColorName.neural600),
                          ),
                        ),
                        TTextField(
                          initText: initialAccount,
                          labelText: 'Broker Account',
                          picture: Assets.icons.frame,
                          onChanged: (account) => context
                              .read<EditBrokerBloc>()
                              .add(AccountChanged(account)),
                          validator: (value) => null,
                          enabled: isEdit,
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'PASSWORD (optional)',
                            style: textTheme.bodySmall!
                                .copyWith(color: ColorName.neural600),
                          ),
                        ),
                        TTextField(
                          initText: initialPassword,
                          labelText: 'Broker Password',
                          picture: Assets.icons.key,
                          onChanged: (password) => context
                              .read<EditBrokerBloc>()
                              .add(PasswordChanged(password)),
                          validator: (value) => null,
                          enabled: isEdit,
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
    // get is edit
    final isEdit = context.select((EditBrokerBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((EditBrokerBloc bloc) => bloc.state.isAdmin);

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
                        context.read<EditBrokerBloc>().add(const Submitted());
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
                        .read<EditBrokerBloc>()
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
    final initialBroker =
        context.select((EditBrokerBloc bloc) => bloc.state.initialBroker);
    // get is edit
    final isEdit =
        context.select((EditBrokerBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          initialBroker == null
              ? 'NEW BROKER'
              : isEdit
                  ? 'EDIT BROKER'
                  : 'BROKER DETAIL',
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
