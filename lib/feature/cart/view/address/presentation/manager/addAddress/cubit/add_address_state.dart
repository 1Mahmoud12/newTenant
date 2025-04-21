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
