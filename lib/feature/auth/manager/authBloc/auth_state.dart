abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthGetCountryCodeLoadingState extends AuthState {}

class AuthGetCountryCodeSuccessState extends AuthState {}

class AuthGetCountryCodeErrorState extends AuthState {
  String error;

  AuthGetCountryCodeErrorState(this.error);
}

class AuthSignUpLoadingState extends AuthState {}

class AuthSignUpSuccessState extends AuthState {}

class AuthSignUpErrorState extends AuthState {
  String error;

  AuthSignUpErrorState(this.error);
}

//Verify
class AuthVerifyLoadingState extends AuthState {}

class AuthVerifySuccessState extends AuthState {}

class AuthVerifyErrorState extends AuthState {
  String error;

  AuthVerifyErrorState(this.error);
}

//Login
class AuthLoginLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthLoginErrorState extends AuthState {
  String error;

  AuthLoginErrorState(this.error);
}

//Reset Password
class AuthResetPasswordLoadingState extends AuthState {}

class AuthResetPasswordSuccessState extends AuthState {}

class AuthResetPasswordErrorState extends AuthState {
  String error;

  AuthResetPasswordErrorState(this.error);
}

//Re send Code
class AuthResendCodeLoadingState extends AuthState {}

class AuthResendCodeSuccessState extends AuthState {}

class AuthResendCodeErrorState extends AuthState {
  String error;

  AuthResendCodeErrorState(this.error);
}

class RememberMeState extends AuthState {}

class AuthSetGenderState extends AuthState {}

class AuthSetCountryCodeState extends AuthState {}

class AuthSetCodeState extends AuthState {}
