import 'package:formz/formz.dart';

/// Project Name Form Input Validation Error.
enum ProjectNameValidationError {
  /// Project Name is invalid (generic validation error).
  invalid
}

/// {@template Project_name}
/// Reusable Project name form input.
/// {@endtemplate}
class ProjectName extends FormzInput<String, ProjectNameValidationError> {
  /// {@macro Project_name}
  const ProjectName.pure() : super.pure('');

  /// {@macro Project_name}
  const ProjectName.dirty([super.value = '']) : super.dirty();

  @override
  ProjectNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : ProjectNameValidationError.invalid;
  }
}
