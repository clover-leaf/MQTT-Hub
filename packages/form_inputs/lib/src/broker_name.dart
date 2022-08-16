import 'package:formz/formz.dart';

/// BrokerName Form Input Validation Error.
enum BrokerNameValidationError {
  /// BrokerName is invalid (generic validation error).
  invalid
}

/// {@template BrokerName}
/// Reusable BrokerName form input.
/// {@endtemplate}
class BrokerName extends FormzInput<String, BrokerNameValidationError> {
  /// {@macro BrokerName}
  const BrokerName.pure() : super.pure('');

  /// {@macro BrokerName}
  const BrokerName.dirty([super.value = '']) : super.dirty();

  @override
  BrokerNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : BrokerNameValidationError.invalid;
  }
}
