import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bee/edit_broker/edit_broker.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class EditBrokerView extends StatelessWidget {
  const EditBrokerView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditBrokerBloc, EditBrokerState>(
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
        BlocListener<EditBrokerBloc, EditBrokerState>(
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
                      message: state.initBroker == null
                          ? 'New broker has been created'
                          : 'Broker has been updated',
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
          _Input(
            label: 'Broker Name',
            hintText: 'Your Broker Name',
            onChagned: (brokerName) => context
                .read<EditBrokerBloc>()
                .add(EditBrokerNameChanged(brokerName)),
          ),
          _Input(
            label: 'Broker Url',
            hintText: 'Your Broker Url',
            onChagned: (urlName) => context
                .read<EditBrokerBloc>()
                .add(EditUrlNameChanged(urlName)),
          ),
          _Input(
            label: 'Broker Account (optional)',
            hintText: 'Your Broker Account',
            onChagned: (brokerAccount) => context
                .read<EditBrokerBloc>()
                .add(EditBrokerAccountChanged(brokerAccount)),
          ),
          _Input(
            label: 'Broker Password (optional)',
            hintText: 'Your Broker Password',
            onChagned: (brokerPassword) => context
                .read<EditBrokerBloc>()
                .add(EditBrokerPasswordChanged(brokerPassword)),
          ),
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
    final initBroker =
        context.select((EditBrokerBloc bloc) => bloc.state.initBroker);
    final project =
        context.select((EditBrokerBloc bloc) => bloc.state.project);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            initBroker == null ? 'New Broker' : 'Edit Broker',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            project.name,
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.hintText,
    required this.onChagned,
  });

  final String label;
  final String hintText;
  final void Function(String) onChagned;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isInProgress = context.select(
      (EditBrokerBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );

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
            onChanged: onChagned,
          ),
        ],
      ),
    );
  }
}
