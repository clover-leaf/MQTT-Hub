import 'package:bee/app/bloc/app_bloc.dart';
import 'package:bee/components/t_password_field.dart';
import 'package:bee/components/t_snackbar.dart';
import 'package:bee/components/t_text_field.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/login/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // use ListView to make page scroll up when keyboard comes
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isProcessing()) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
          if (state.status.isSuccess()) {
            context.read<AppBloc>().add(
                  AppAuthenticated(
                    token: state.token!,
                    toWrite: true,
                    isAdmin: state.isAdmin!,
                  ),
                );
          } else if (state.status.isFailure()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.error(context, content: state.error!),
              );
          }
        }
      },
      child: GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 32,
            ),
            children: [
              const _Header(),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TTextField(
                      initText: null,
                      labelText: 'Company Name',
                      picture: Assets.icons.box,
                      onChanged: (domainName) {
                        context
                            .read<LoginBloc>()
                            .add(LoginDomainNameChanged(domainName));
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valid string';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TTextField(
                      initText: null,
                      labelText: 'Username',
                      picture: Assets.icons.frame,
                      onChanged: (username) => context
                          .read<LoginBloc>()
                          .add(LoginUsernameChanged(username)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valid string';
                        }
                        return null;
                      },
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    TPasswordField(
                      initText: null,
                      labelText: 'Password',
                      picture: Assets.icons.key,
                      onChanged: (password) => context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(password)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valid string';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 48),
              _LoginButton(formKey: _formKey),
              const SizedBox(height: 128),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign in',
            style: textTheme.displaySmall!.copyWith(
              color: ColorName.neural700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.sky400,
        onPrimary: ColorName.sky600,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        if (formKey.currentState != null && formKey.currentState!.validate()) {
          context.read<LoginBloc>().add(const LoginSubmitted());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Text(
          'Login',
          style: textTheme.labelLarge!.copyWith(
            color: ColorName.white,
          ),
        ),
      ),
    );
  }
}
