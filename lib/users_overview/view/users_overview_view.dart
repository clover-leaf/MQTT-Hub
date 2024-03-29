import 'package:bee/components/component.dart';
import 'package:bee/edit_user/view/edit_user_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/users_overview/components/user_item.dart';
import 'package:bee/users_overview/users_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UsersOverviewView extends StatelessWidget {
  const UsersOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedUsers =
        context.select((UsersOverviewBloc bloc) => bloc.state.showedUsers);
    final projects =
        context.select((UsersOverviewBloc bloc) => bloc.state.projects);
    final userProjects =
        context.select((UsersOverviewBloc bloc) => bloc.state.userProjects);
    final isAdmin =
        context.select((UsersOverviewBloc bloc) => bloc.state.isAdmin);
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return BlocListener<UsersOverviewBloc, UsersOverviewState>(
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
                  content: 'User has deleted successfully',
                ),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
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
      child: Column(
        children: [
          SizedBox(height: paddingTop),
          _Header(isAdmin: isAdmin),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const _Title(),
                const SizedBox(height: 20),
                ...showedUsers.map((user) {
                  return Column(
                    children: [
                      UserItem(
                        isAdmin: isAdmin,
                        user: user,
                        onPressed: () {
                          final initialUserProjects = userProjects
                              .where((usPr) => usPr.userID == user.id)
                              .toList();
                          Navigator.of(context).push(
                            EditUserPage.route(
                              initialProjects: projects,
                              initialUserProjects: initialUserProjects,
                              initialUser: user,
                              isEdit: false,
                            ),
                          );
                        },
                        onDeletePressed: () => context
                            .read<UsersOverviewBloc>()
                            .add(DeletionRequested(user.id)),
                      ),
                      const SizedBox(height: 16)
                    ],
                  );
                }).toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final projects =
        context.select((UsersOverviewBloc bloc) => bloc.state.projects);

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
            child: TSecondaryButton(
              label: 'ADD USER',
              onPressed: () => Navigator.of(context).push(
                EditUserPage.route(
                  initialProjects: projects,
                  initialUserProjects: [],
                  initialUser: null,
                  isEdit: true,
                ),
              ),
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
    final parentProject =
        context.select((UsersOverviewBloc bloc) => bloc.state.parentProject);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'USERS',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.05,
            color: ColorName.neural700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          parentProject?.name ?? 'Overview',
          style: textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorName.neural600,
          ),
        ),
      ],
    );
  }
}
