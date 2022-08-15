import 'package:bee/app/bloc/app_bloc.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/projects_overview/view/projects_overview_page.dart';
import 'package:bee/tiles_overview/tiles_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class TilesOverviewPage extends StatelessWidget {
  const TilesOverviewPage({super.key});

  static Page<void> page() => MaterialPage<void>(
        child: BlocProvider(
          create: (context) => TilesOverviewBloc(context.read<UserRepository>())
            ..add(const TilesOverviewInitializationRequested()),
          child: const TilesOverviewPage(),
        ),
      );

  static PageRoute<void> route() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => TilesOverviewBloc(context.read<UserRepository>())
          ..add(const TilesOverviewInitializationRequested()),
        child: const TilesOverviewPage(),
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
        onPressed: () {},
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
                onPressed: () async {
                  await showMaterialModalBottomSheet<void Function()>(
                    context: context,
                    builder: (bContext) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BottomSheetProjectItem(
                          label: 'Lonely',
                          onPressed: () {},
                        ),
                        _BottomSheetProjectItem(
                          label: 'Lonely',
                          onPressed: () {},
                        ),
                        const Divider(height: 1),
                        _BottomSheetItem(
                          picture: Assets.icons.box2.svg(),
                          label: 'Project',
                          onPressed: () => Navigator.of(bContext).pop(
                            () => Navigator.of(context).push<void>(
                              ProjectsOverviewPage.route(),
                            ),
                          ),
                        ),
                        _BottomSheetItem(
                          picture: Assets.icons.setting.svg(),
                          label: 'Setting',
                          onPressed: () {},
                        ),
                        _BottomSheetItem(
                          picture: Assets.icons.logout.svg(),
                          label: 'Logout',
                          onPressed: () => Navigator.of(bContext).pop(
                            () => context
                                .read<AppBloc>()
                                .add(const AppUnauthenticated()),
                          ),
                        ),
                      ],
                    ),
                  ).then((callback) {
                    if (callback != null) {
                      callback.call();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const CircleBorder(),
                  primary: ColorName.white,
                  onPrimary: ColorName.blue,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                ),
                child: Assets.icons.textalignLeft.svg(),
              ),
              ElevatedButton(
                onPressed: () async {
                  await showMaterialModalBottomSheet<void>(
                    context: context,
                    builder: (context) => Container(),
                  );
                },
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
      body: const TilesOverviewView(),
    );
  }
}

class _BottomSheetProjectItem extends StatelessWidget {
  const _BottomSheetProjectItem({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: ColorName.white,
        onPrimary: ColorName.blue,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: ColorName.darkBlue,
              child: Text(
                label[0].toUpperCase(),
                style: textTheme.titleMedium!.copyWith(
                  color: ColorName.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Text(label, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _BottomSheetItem extends StatelessWidget {
  const _BottomSheetItem({
    required this.picture,
    required this.label,
    required this.onPressed,
  });

  final SvgPicture picture;
  final String label;
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: picture,
          ),
          Text(label, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
