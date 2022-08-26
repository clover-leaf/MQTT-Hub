import 'package:bee/components/component.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class ProjectSheet extends StatelessWidget {
  const ProjectSheet({
    super.key,
    required this.projects,
    required this.onSelectProject,
  });

  final List<Project> projects;
  final void Function(Project) onSelectProject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
          if (projects.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.center,
              height: 96,
              child: Text(
                'No project left',
                style: textTheme.titleSmall,
              ),
            )
          else
            ...projects.map(
              (pr) => TProjectItem(
                label: pr.name,
                onPressed: () => onSelectProject(pr),
              ),
            )
        ],
      ),
    );
  }
}
