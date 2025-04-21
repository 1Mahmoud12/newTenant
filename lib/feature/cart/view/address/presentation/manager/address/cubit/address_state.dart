part of 'address_cubit.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressSuccess extends AddressState {}

final class AddressError extends AddressState {
  final String e;

  AddressError({required this.e});
}
