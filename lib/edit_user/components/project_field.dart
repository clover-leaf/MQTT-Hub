import 'package:bee/components/component.dart';
import 'package:bee/edit_user/bloc/bloc.dart';
import 'package:bee/edit_user/sheets/project_sheet.dart';
import 'package:bee/gen/assets.gen.dart';
import 'package:bee/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class ProjectField extends StatefulWidget {
  const ProjectField({
    super.key,
    required this.userID,
    required this.initialProjects,
    required this.userProjects,
    required this.enabled,
  });

  final String userID;
  final List<Project> initialProjects;
  final List<UserProject> userProjects;
  final bool enabled;

  @override
  State<ProjectField> createState() => _ProjectFieldState();
}

class _ProjectFieldState extends State<ProjectField> {
  late String _userID;
  late List<UserProject> _userProjects;
  late List<Project> _projects;
  late List<Project> _showedProjects;

  @override
  void initState() {
    _userID = widget.userID;
    _userProjects = widget.userProjects;
    _projects = widget.initialProjects;
    // get list of selected project
    final selectedProjectIDs =
        widget.userProjects.map((usPr) => usPr.projectID).toList();
    _showedProjects =
        _projects.where((pr) => selectedProjectIDs.contains(pr.id)).toList();
    super.initState();
  }

  void updateBloc(BuildContext context, List<UserProject> userProjects) {
    context.read<EditUserBloc>().add(UserProjectsChanged(userProjects));
    final selectedProjectIDs =
        userProjects.map((usPr) => usPr.projectID).toList();
    final showedProjects =
        _projects.where((pr) => selectedProjectIDs.contains(pr.id)).toList();
    setState(() {
      _userProjects = userProjects;
      _showedProjects = showedProjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    // get text theme of context
    final textTheme = Theme.of(context).textTheme;

    return FormField(
      initialValue: _userProjects,
      validator: (_) {
        if (_userProjects.isEmpty) {
          return 'User must have access at least one project';
        }
        return null;
      },
      builder: (projectFormFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROJECT ACCESSIBILITY',
                style:
                    textTheme.bodySmall!.copyWith(color: ColorName.neural600),
              ),
              TAddButton(
                label: 'ADD PROJECT',
                onPressed: () async {
                  if (widget.enabled) {
                    await showMaterialModalBottomSheet<Project?>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (bContext) {
                        final selectedProjectIDs = _userProjects
                            .map((usPr) => usPr.projectID)
                            .toList();
                        final notSelectedProjects = _projects
                            .where(
                              (pr) => !selectedProjectIDs.contains(pr.id),
                            )
                            .toList();
                        return ProjectSheet(
                          projects: notSelectedProjects,
                          onSelectProject: (project) =>
                              Navigator.of(bContext).pop(project),
                        );
                      },
                    ).then((project) {
                      if (project != null) {
                        final usPr = UserProject(
                          userID: _userID,
                          projectID: project.id,
                        );
                        final userProjects =
                            List<UserProject>.from(_userProjects)..add(usPr);
                        updateBloc(context, userProjects);
                      }
                      return null;
                    });
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          ..._showedProjects.map(
            (pr) => _ProjectItem(
              project: pr,
              enabled: widget.enabled,
              onDelete: (delProject) {
                final userProjects = List<UserProject>.from(_userProjects)
                  ..removeWhere((usPr) => usPr.projectID == delProject.id);
                updateBloc(context, userProjects);
              },
            ),
          ),
          // List ranges error line
          if (projectFormFieldState.hasError)
            Text(
              projectFormFieldState.errorText!,
              style: textTheme.labelMedium!.copyWith(
                color: ColorName.wine300,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  const _ProjectItem({
    required this.project,
    required this.onDelete,
    required this.enabled,
  });

  final Project project;
  final bool enabled;
  final void Function(Project) onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TProjectItem(
            key: ValueKey(project.id),
            label: project.name,
            onPressed: () {},
          ),
        ),
        TCircleButton(
          picture: Assets.icons.trash
              .svg(color: ColorName.neural600, fit: BoxFit.scaleDown),
          onPressed: () {
            if (enabled) {
              onDelete(project);
            }
          },
        )
      ],
    );
  }
}
