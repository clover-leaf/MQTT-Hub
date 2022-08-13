import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TilesOverviewView extends StatelessWidget {
  const TilesOverviewView({super.key});

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
        child: Assets.icons.box.svg(color: ColorName.white),
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
                  await showMaterialModalBottomSheet<void>(
                    context: context,
                    builder: (context) => Column(
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
                        const Divider(
                          height: 1,
                          color: ColorName.blueGray,
                        ),
                        _BottomSheetItem(
                          picture: Assets.icons.lock.svg(),
                          label: 'Project',
                          onPressed: () {},
                        ),
                        _BottomSheetItem(
                          picture: Assets.icons.lock.svg(),
                          label: 'Setting',
                          onPressed: () {},
                        ),
                        _BottomSheetItem(
                          picture: Assets.icons.lock.svg(),
                          label: 'Logout',
                          onPressed: () {},
                        ),
                      ],
                    ),
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
              ElevatedButton(
                onPressed: () async {
                  await showMaterialModalBottomSheet(
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
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 32,
        ),
        children: const [
          Text('Dashboard'),
        ],
      ),
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
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
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
