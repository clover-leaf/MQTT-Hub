import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bee/edit_project/edit_project.dart';
import 'package:bee/edit_user/edit_user.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

class EditUserView extends StatelessWidget {
  const EditUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.select((EditUserBloc bloc) => bloc.state.projects);

    return MultiBlocListener(
      listeners: [
        BlocListener<EditUserBloc, EditUserState>(
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
        BlocListener<EditUserBloc, EditUserState>(
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
                      message: state.initUser == null
                          ? 'New user has been created'
                          : 'User has been updated',
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
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: [
          const _Header(),
          _Input(
            label: 'Username',
            hintText: 'Username',
            onChanged: (username) =>
                context.read<EditUserBloc>().add(EditUsernameChanged(username)),
          ),
          _Input(
            label: 'Password',
            hintText: 'Password',
            onChanged: (password) =>
                context.read<EditUserBloc>().add(EditPasswordChanged(password)),
          ),
          const _SessionTitle('Project Accessibility'),
          ...projects.map(_ProjectItem.new)
        ],
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  const _ProjectItem(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final selectedProjectIDs =
        context.select((EditUserBloc bloc) => bloc.state.selectedProjectIDs);
    final isSelected = selectedProjectIDs.contains(project.id);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () {
        if (isSelected) {
          context.read<EditUserBloc>().add(EditProjectDeleted(project.id));
        } else {
          context.read<EditUserBloc>().add(EditProjectAdded(project.id));
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              project.name,
              style: textTheme.labelLarge,
            ),
            Assets.icons.box2.svg(
              color: isSelected ? ColorName.darkGray : theme.backgroundColor,
            )
          ],
        ),
      ),
    );
  }
}

class _SessionTitle extends StatelessWidget {
  const _SessionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
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
              EditProjectPage.route(initProject: null),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.icons.add.svg(color: ColorName.white),
                  Text(
                    'New Project',
                    style:
                        textTheme.labelMedium!.copyWith(color: ColorName.white),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final initUser = context.select((EditUserBloc bloc) => bloc.state.initUser);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      child: Text(
        initUser == null ? 'New User' : 'Edit User',
        style: textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.hintText,
    required this.onChanged,
  });

  final String label;
  final String hintText;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isInProgress = context.select(
      (EditUserBloc bloc) => bloc.state.status.isSubmissionInProgress,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
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
