import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/users_overview/users_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class UsersOverviewView extends StatelessWidget {
  const UsersOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final showedUsers =
        context.select((UsersOverviewBloc bloc) => bloc.state.showedUsers);

    return BlocListener<UsersOverviewBloc, UsersOverviewState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'On Snap!',
                message: state.error,
                contentType: ContentType.failure,
              ),
            ),
          );
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
        ),
        children: [const _Header(), ...showedUsers.map(_UserItem.new)],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parentProject =
        context.select((UsersOverviewBloc bloc) => bloc.state.parentProject);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parentProject != null ? parentProject.name : 'Users',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            parentProject != null ? 'Users' : 'Overview',
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserItem extends StatelessWidget {
  const _UserItem(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () => {},
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
            Assets.icons.more.svg()
          ],
        ),
      ),
    );
  }
}
