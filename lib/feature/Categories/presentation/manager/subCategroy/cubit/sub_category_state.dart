part of 'sub_category_cubit.dart';

@immutable
sealed class SubCategoryState {}

final class SubCategoryInitial extends SubCategoryState {}
final class SubCategoryLoading extends SubCategoryState {}
final class SubCategorySuccess extends SubCategoryState {}
final class SubCategoryError extends SubCategoryState {final String e; SubCategoryError({required this.e});}
