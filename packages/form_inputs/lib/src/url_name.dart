import 'package:formz/formz.dart';

/// UrlName Form Input Validation Error.
enum UrlNameValidationError {
  /// UrlName is invalid (generic validation error).
  invalid
}

/// {@template UrlName}
/// Reusable UrlName form input.
/// {@endtemplate}
class UrlName extends FormzInput<String, UrlNameValidationError> {
  /// {@macro UrlName}
  const UrlName.pure() : super.pure('');

  /// {@macro UrlName}
  const UrlName.dirty([super.value = '']) : super.dirty();

  @override
  UrlNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : UrlNameValidationError.invalid;
  }
}
