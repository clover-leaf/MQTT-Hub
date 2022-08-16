import 'package:formz/formz.dart';

/// BrokerPassword Form Input Validation Error.
enum BrokerPasswordValidationError {
  /// BrokerPassword is invalid (generic validation error).
  invalid
}

/// {@template BrokerPassword}
/// Reusable BrokerPassword form input.
/// {@endtemplate}
class BrokerPassword extends FormzInput<String, BrokerPasswordValidationError> {
  /// {@macro BrokerPassword}
  const BrokerPassword.pure() : super.pure('');

  /// {@macro BrokerPassword}
  const BrokerPassword.dirty([super.value = '']) : super.dirty();

  @override
  BrokerPasswordValidationError? validator(String value) {
    return null;
  }
}
