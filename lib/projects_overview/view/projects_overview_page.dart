import 'package:bee/edit_project/view/edit_project_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/projects_overview/projects_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ProjectsOverviewPage extends StatelessWidget {
  const ProjectsOverviewPage({super.key});

  static PageRoute<void> route() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) =>
            ProjectsOverviewBloc(context.read<UserRepository>())
              ..add(const ProjectSubscriptionRequested()),
        child: const ProjectsOverviewPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
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

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorName.blue,
        splashColor: ColorName.darkBlue,
        foregroundColor: ColorName.darkBlue,
        onPressed: () => Navigator.of(context).push(
          EditProjectPage.route(initProject: null),
        ),
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
      body: const ProjectsOverviewView(),
    );
  }
}
