import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bee/edit_project/bloc/edit_project_bloc.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class EditProjectView extends StatelessWidget {
  const EditProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProjectBloc, EditProjectState>(
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
        BlocListener<EditProjectBloc, EditProjectState>(
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
                      message: state.initProject == null
                          ? 'New project has been created'
                          : 'Project has been updated',
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
        children: const [
          _Header(),
          _ProjectNameInput(),
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
    final initProject =
        context.select((EditProjectBloc bloc) => bloc.state.initProject);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        initProject == null ? 'New Project' : 'Edit Project',
        style: textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ProjectNameInput extends StatelessWidget {
  const _ProjectNameInput();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isInProgress = context.select(
      (EditProjectBloc bloc) =>
          bloc.state.status.isSubmissionInProgress,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Project Name',
              style: textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextFormField(
            readOnly: isInProgress,
            style: textTheme.labelLarge,
            decoration: InputDecoration(
              hintText: 'Your Project Name',
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
            onChanged: (projectName) => context
                .read<EditProjectBloc>()
                .add(EditProjectNameChanged(projectName)),
          ),
        ],
      ),
    );
  }
}
