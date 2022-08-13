import 'package:formz/formz.dart';

/// Domain Name Form Input Validation Error.
enum DomainNameValidationError {
  /// Domain Name is invalid (generic validation error).
  invalid
}

/// {@template Domain_name}
/// Reusable Domain name form input.
/// {@endtemplate}
class DomainName extends FormzInput<String, DomainNameValidationError> {
  /// {@macro Domain_name}
  const DomainName.pure() : super.pure('');

  /// {@macro Domain_name}
  const DomainName.dirty([super.value = '']) : super.dirty();

  @override
  DomainNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : DomainNameValidationError.invalid;
  }
}
