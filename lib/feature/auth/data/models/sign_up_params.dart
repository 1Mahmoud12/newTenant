class SignUpParams {
  final String firstName;
  final String email;
  final String lastName;
  final String password;
  final int termAndCondition;

  SignUpParams({
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.password,
    required this.termAndCondition,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'email': email,
      'last_name': lastName,
      'password': password,
      'agree_terms': termAndCondition,
    };
  }
}
/*
{
  FullName: string,
  Email: user@example.com,
  Birthday: 2024-10-07T16:24:49.935Z,
  PhoneNumber: string,
  Gender: 1,
  UserName: string,
  Password: stringst,
  CountryCodeId: 0
}
 */
