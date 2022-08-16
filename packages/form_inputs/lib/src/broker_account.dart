import 'package:formz/formz.dart';

/// BrokerAccount Form Input Validation Error.
enum BrokerAccountValidationError {
  /// BrokerAccount is invalid (generic validation error).
  invalid
}

/// {@template BrokerAccount}
/// Reusable BrokerAccount form input.
/// {@endtemplate}
class BrokerAccount extends FormzInput<String, BrokerAccountValidationError> {
  /// {@macro BrokerAccount}
  const BrokerAccount.pure() : super.pure('');

  /// {@macro BrokerAccount}
  const BrokerAccount.dirty([super.value = '']) : super.dirty();

  @override
  BrokerAccountValidationError? validator(String value) {
    return null;
  }
}
