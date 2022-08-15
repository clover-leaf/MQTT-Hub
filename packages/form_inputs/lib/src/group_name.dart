import 'package:formz/formz.dart';

/// Group Name Form Input Validation Error.
enum GroupNameValidationError {
  /// Group Name is invalid (generic validation error).
  invalid
}

/// {@template Group_name}
/// Reusable Group name form input.
/// {@endtemplate}
class GroupName extends FormzInput<String, GroupNameValidationError> {
  /// {@macro Group_name}
  const GroupName.pure() : super.pure('');

  /// {@macro Group_name}
  const GroupName.dirty([super.value = '']) : super.dirty();

  @override
  GroupNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : GroupNameValidationError.invalid;
  }
}
