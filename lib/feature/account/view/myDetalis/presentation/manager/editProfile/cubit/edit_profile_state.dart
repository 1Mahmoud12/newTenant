part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {}

final class EditProfileError extends EditProfileState {
  final String e;

  EditProfileError({required this.e});
}

final class UpdateProfileLoading extends EditProfileState {}

final class UpdateProfileSuccess extends EditProfileState {}

final class UpdateProfileError extends EditProfileState {
  final String e;

  UpdateProfileError({required this.e});
}
