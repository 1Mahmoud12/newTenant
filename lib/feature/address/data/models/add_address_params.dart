class AddAddressParams {
  final String themeId;
  final String customerId;
  final String title;
  final String address;
  final String country;
  final String state;
  final String city;
  final String postcode;
  final bool isDefault;

  AddAddressParams({
    required this.themeId,
    required this.customerId,
    required this.title,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.postcode,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'theme_id': themeId,
      'customer_id': customerId, // backend expects string
      'title': title,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'postcode': postcode,
      'default_address': isDefault ? '1' : '0',
    };
  }
}
