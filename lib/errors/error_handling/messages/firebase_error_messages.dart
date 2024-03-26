import 'package:stoyco_shared/errors/error_handling/codes/firebase_error_codes.dart';

const Map<FirebaseErrorCode, String> firebaseErrorMessages = {
  FirebaseErrorCode.invalidVerificationCode: 'El código ingresado no es válido',
  FirebaseErrorCode.invalidPhoneNumber:
      'El número de celular ingresado es inválido',
  FirebaseErrorCode.tooManyRequests:
      'Se han realizado muchos intentos de registro usando este número, por favor intenta más tarde.',
  FirebaseErrorCode.emailAlreadyInUse:
      'La dirección de correo ya ha sido utilizada por otra persona',
  FirebaseErrorCode.accountExistsWithDifferentCredential:
      'Ya existe una cuenta con la misma dirección de correo electrónico pero con diferentes credenciales de inicio de sesión. Inicie sesión con un proveedor asociado con esta dirección de correo electrónico.',
  FirebaseErrorCode.userNotFound:
      'No se encontró un usuario con ese correo electrónico.',
  FirebaseErrorCode.invalidPassword: 'Contraseña incorrecta para ese usuario.',
  FirebaseErrorCode.userDisabled: 'El usuario ha sido deshabilitado',
  FirebaseErrorCode.unknownError: 'Ocurrió un error desconocido.',
};

FirebaseErrorCode parseFirebaseErrorCode(String? errorCode) {
  const Map<String, FirebaseErrorCode> errorCodeMap = {
    'invalid-verification-code': FirebaseErrorCode.invalidVerificationCode,
    'invalid-phone-number': FirebaseErrorCode.invalidPhoneNumber,
    'user-disabled': FirebaseErrorCode.userDisabled,
    'user-not-found': FirebaseErrorCode.userNotFound,
    'too-many-requests': FirebaseErrorCode.tooManyRequests,
    'email-already-in-use': FirebaseErrorCode.emailAlreadyInUse,
    'account-exists-with-different-credential':
        FirebaseErrorCode.accountExistsWithDifferentCredential,
    'invalid-password': FirebaseErrorCode.invalidPassword,
  };

  return errorCodeMap[errorCode] ?? FirebaseErrorCode.unknownError;
}
