import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bee/app/bloc/app_bloc.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/login/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // use ListView to make page scroll up when keyboard comes
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
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
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              context
                  .read<AppBloc>()
                  .add(AppAuthenticated(token: state.token!, toWrite: true));
            }
          },
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 32,
        ),
        children: const [
          _Header(),
          _DomainNameInput(),
          _EmailInput(),
          _PasswordInput(),
          _LoginButton(),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
      child: Text(
        'Login',
        style: textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DomainNameInput extends StatelessWidget {
  const _DomainNameInput();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isInProgress = context.select(
      (LoginBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Domain Name',
              style: textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextFormField(
            readOnly: isInProgress,
            style: textTheme.labelLarge,
            decoration: InputDecoration(
              hintText: 'Your Domain Name',
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
              prefixIcon: Assets.icons.box.svg(
                color: ColorName.blueGray,
                fit: BoxFit.scaleDown,
              ),
            ),
            onChanged: (domainName) => context
                .read<LoginBloc>()
                .add(LoginDomainNameChanged(domainName)),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isInProgress = context.select(
      (LoginBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'E-mail',
              style: textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextFormField(
            readOnly: isInProgress,
            keyboardType: TextInputType.emailAddress,
            style: textTheme.labelLarge,
            decoration: InputDecoration(
              hintText: 'Your Email',
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
              prefixIcon: Assets.icons.sms.svg(
                color: ColorName.blueGray,
                fit: BoxFit.scaleDown,
              ),
            ),
            onChanged: (email) =>
                context.read<LoginBloc>().add(LoginEmailChanged(email)),
          ),
        ],
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final passwordVisible = context.select(
      (LoginBloc bloc) => bloc.state.passwordVisible,
    );
    final isInProgress = context.select(
      (LoginBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Password',
              style: textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextFormField(
            style: textTheme.labelLarge,
            readOnly: isInProgress,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              hintText: 'Your Password',
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
              prefixIcon: Assets.icons.lock.svg(
                color: ColorName.blueGray,
                fit: BoxFit.scaleDown,
              ),
              suffixIcon: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.read<LoginBloc>().add(
                      LoginPasswordVisibleChanged(
                        passwordVisible: !passwordVisible,
                      ),
                    ),
                child: passwordVisible
                    ? Assets.icons.eye.svg(
                        color: ColorName.blueGray,
                        fit: BoxFit.scaleDown,
                      )
                    : Assets.icons.eyeSlash.svg(
                        color: ColorName.blueGray,
                        fit: BoxFit.scaleDown,
                      ),
              ),
            ),
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(ColorName.darkLavender),
          backgroundColor: MaterialStateProperty.all(ColorName.lavender),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
        onPressed: () => context.read<LoginBloc>().add(
              LoginSubmitted(
                domainName: state.domainName.value,
                username: state.email.value,
                password: state.password.value,
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            state.status.isSubmissionInProgress ? 'Loading' : 'Login',
            style: textTheme.labelLarge!.copyWith(
              color: ColorName.white,
            ),
          ),
        ),
      ),
    );
  }
}
