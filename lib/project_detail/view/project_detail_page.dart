import 'package:bee/edit_group/view/edit_group_page.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/project_detail/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key});

  static PageRoute<void> route(Project project) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => ProjectDetailBloc(project),
        child: const ProjectDetailPage(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
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
    final project =
        context.select((ProjectDetailBloc bloc) => bloc.state.project);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorName.blue,
        splashColor: ColorName.darkBlue,
        foregroundColor: ColorName.darkBlue,
        onPressed: () async {
          await showMaterialModalBottomSheet<void Function()>(
            context: context,
            builder: (bContext) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BottemSheetItem(
                  label: 'Group',
                  onPressed: () => Navigator.of(bContext).pop(
                    () => Navigator.of(context).push(
                      EditGroupPage.route(
                        project: project,
                        group: null,
                        initGroup: null,
                      ),
                    ),
                  ),
                ),
                _BottemSheetItem(
                  label: 'Device',
                  onPressed: () => Navigator.of(bContext).pop(
                    () {},
                  ),
                )
              ],
            ),
          ).then((callback) {
            if (callback != null) {
              callback.call();
            }
          });
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
      body: const ProjectDetailView(),
    );
  }
}

class _BottemSheetItem extends StatelessWidget {
  const _BottemSheetItem({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: ColorName.white,
          onPrimary: ColorName.blue,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Assets.icons.lock.svg(),
              ),
              Text(label, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
