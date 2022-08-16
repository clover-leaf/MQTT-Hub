import 'package:bee/edit_user/edit_user.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/users_overview/users_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class UsersOverviewPage extends StatelessWidget {
  const UsersOverviewPage({super.key});

  static PageRoute<void> route(Project? parentProject) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => UsersOverviewBloc(
          context.read<UserRepository>(),
          parentProject: parentProject,
        )
          ..add(const UserSubscriptionRequested())
          ..add(const UserProjectSubscriptionRequested()),
        child: const UsersOverviewPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin =
            parentProject != null ? const Offset(1, 0) : const Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentProject =
        context.select((UsersOverviewBloc bloc) => bloc.state.parentProject);
    final users = context.select((UsersOverviewBloc bloc) => bloc.state.users);
    final showedUsers =
        context.select((UsersOverviewBloc bloc) => bloc.state.showedUsers);
    final nonMemberUsers = users.where((us) => !showedUsers.contains(us));

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorName.blue,
        splashColor: ColorName.darkBlue,
        foregroundColor: ColorName.darkBlue,
        onPressed: () async {
          if (parentProject != null) {
            // if show user of project, then show option to add old user
            await showMaterialModalBottomSheet<void Function()>(
              context: context,
              builder: (bContext) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    color: theme.backgroundColor,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: ColorName.blue,
                        onPrimary: ColorName.darkBlue,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      onPressed: () => Navigator.of(bContext).pop(
                        () => Navigator.of(context).push(
                          EditUserPage.route(
                            initProject: parentProject,
                            initUserProjects: [],
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.add.svg(color: ColorName.white),
                            Text(
                              'Add new user',
                              style: theme.textTheme.labelMedium!
                                  .copyWith(color: ColorName.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...nonMemberUsers
                      .map(
                        (us) => _UserItem(
                          user: us,
                          onPressed: () => Navigator.of(bContext).pop(
                            () => context.read<UsersOverviewBloc>().add(
                                  UserAdded(user: us, project: parentProject),
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ).then((callback) {
              if (callback != null) {
                callback.call();
              }
            });
          } else {
            // if show user of all domain then navigate to add new user
            await Navigator.of(context).push(
              EditUserPage.route(
                initProject: parentProject,
                initUserProjects: [],
              ),
            );
          }
        },
        child: Assets.icons.add.svg(color: ColorName.white),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.backgroundColor,
        elevation: 24,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.blue,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.arrowLeft.svg(),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.blue,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.lock.svg(),
              ),
            ],
          ),
        ),
      ),
      body: const UsersOverviewView(),
    );
  }
}

class _UserItem extends StatelessWidget {
  const _UserItem({required this.user, required this.onPressed});

  final User user;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user.username,
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
