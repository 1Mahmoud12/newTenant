part of 'add_address_cubit.dart';

@immutable
sealed class AddAddressState {}

final class AddAddressInitial extends AddAddressState {}

final class AddAddressLoading extends AddAddressState {}

final class AddAddressSuccess extends AddAddressState {}

final class AddAddressError extends AddAddressState {
  final String e;

  AddAddressError({required this.e});
}

final class UpdateAddressLoading extends AddAddressState {}

final class UpdateAddressSuccess extends AddAddressState {}

final class UpdateAddressError extends AddAddressState {
  final String e;

  UpdateAddressError({required this.e});
}

// New states for loading countries, states, and cities
final class CountriesLoading extends AddAddressState {}

final class CountriesLoaded extends AddAddressState {}

final class CountriesError extends AddAddressState {
  final String e;

  CountriesError({required this.e});
}

final class StatesLoading extends AddAddressState {}

final class StatesLoaded extends AddAddressState {}

final class StatesError extends AddAddressState {
  final String e;

  StatesError({required this.e});
}

final class CitiesLoading extends AddAddressState {}

final class CitiesLoaded extends AddAddressState {}

final class CitiesError extends AddAddressState {
  final String e;

  CitiesError({required this.e});
}
