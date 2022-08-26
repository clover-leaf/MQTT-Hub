import 'package:bee/components/component.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:bee/tiles_overview/dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class MenuSheet extends StatelessWidget {
  const MenuSheet({super.key, required this.projects, required this.isAdmin});

  final List<Project> projects;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      decoration: const BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...projects.map(
            (pr) => TProjectItem(
              label: pr.name,
              onPressed: () => Navigator.of(context)
                  .pop({'category': 1, 'project_id': pr.id}),
            ),
          ),
          if (projects.isNotEmpty) const Divider(height: 1),
          _BottomSheetItem(
            picture: Assets.icons.box2,
            label: 'Projects',
            onPressed: () =>
                Navigator.of(context).pop({'category': 2, 'option': 1}),
          ),
          if (isAdmin)
            _BottomSheetItem(
              picture: Assets.icons.profile2user,
              label: 'Users',
              onPressed: () =>
                  Navigator.of(context).pop({'category': 2, 'option': 2}),
            ),
          _BottomSheetItem(
            picture: Assets.icons.logout,
            label: 'Logout',
            onPressed: () => showDialog<bool?>(
              context: context,
              builder: (bContext) => const ConfirmDialog(),
            ).then((value) {
              if (value != null && value) {
                Navigator.of(context).pop({'category': 2, 'option': 3});
              } else {
                Navigator.of(context).pop(null);
              }
            }),
          ),
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

  final SvgGenImage picture;
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ColorName.white,
        onPrimary: ColorName.sky300,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: picture.svg(
              color: ColorName.neural700,
              fit: BoxFit.scaleDown,
            ),
          ),
          Text(label, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
