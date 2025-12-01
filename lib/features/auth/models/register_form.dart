import 'package:formz/formz.dart';
import 'login_form.dart';

/// Name form input validation.
enum NameValidationError { empty, tooShort }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) return NameValidationError.empty;
    if (value.trim().length < 2) return NameValidationError.tooShort;
    return null;
  }
}

/// Password confirmation form input validation.
enum PasswordConfirmationValidationError { mismatch }

class PasswordConfirmation extends FormzInput<String, PasswordConfirmationValidationError> {
  const PasswordConfirmation.pure({this.password = ''}) : super.pure('');
  const PasswordConfirmation.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  PasswordConfirmationValidationError? validator(String value) {
    return value == password ? null : PasswordConfirmationValidationError.mismatch;
  }
}

