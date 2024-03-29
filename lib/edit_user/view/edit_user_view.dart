import 'package:bee/components/component.dart';
import 'package:bee/edit_user/components/project_field.dart';
import 'package:bee/edit_user/edit_user.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_repository/user_repository.dart';

class EditUserView extends StatelessWidget {
  const EditUserView({
    super.key,
    required this.userID,
    required this.initialUser,
    required this.initialProjects,
    required this.userProjects,
  });

  final String userID;
  final User? initialUser;
  final List<Project> initialProjects;
  final List<UserProject> userProjects;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final _formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final isEdit = context.select((EditUserBloc bloc) => bloc.state.isEdit);

    return BlocListener<EditUserBloc, EditUserState>(
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
                  content: state.initialUser == null
                      ? 'New user has been created'
                      : 'User has been updated',
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
                            'USERNAME',
                            style: textTheme.bodySmall!
                                .copyWith(color: ColorName.neural600),
                          ),
                        ),
                        TTextField(
                          initText: initialUser?.username,
                          labelText: 'Username',
                          picture: Assets.icons.frame,
                          enabled: isEdit,
                          onChanged: (username) => context
                              .read<EditUserBloc>()
                              .add(UsernameChanged(username)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'PASSWORD',
                            style: textTheme.bodySmall!
                                .copyWith(color: ColorName.neural600),
                          ),
                        ),
                        TTextField(
                          initText: initialUser?.password,
                          labelText: 'Password',
                          picture: Assets.icons.key,
                          enabled: isEdit,
                          onChanged: (password) => context
                              .read<EditUserBloc>()
                              .add(PasswordChanged(password)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid string';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ProjectField(
                          userID: userID,
                          initialProjects: initialProjects,
                          userProjects: userProjects,
                          enabled: isEdit,
                        )
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
    final isEdit = context.select((EditUserBloc bloc) => bloc.state.isEdit);

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
          child: isEdit
              ? TSecondaryButton(
                  label: 'SAVE',
                  onPressed: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      context.read<EditUserBloc>().add(const Submitted());
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
                      .read<EditUserBloc>()
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
    final initialUser =
        context.select((EditUserBloc bloc) => bloc.state.initialUser);
    final isEdit = context.select((EditUserBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          initialUser == null
              ? 'NEW USER'
              : isEdit
                  ? 'EDIT USER'
                  : 'USER DETAIL',
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
