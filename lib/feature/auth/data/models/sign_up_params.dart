class SignUpParams {
  final String name;
  final String phone;
  final String password;
  final int termAndCondition;

  SignUpParams({
    required this.name,
    required this.phone,
    required this.password,
    required this.termAndCondition,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
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
