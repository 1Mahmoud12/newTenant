abstract class HomeState {}

class HomeInitial extends HomeState {}

class ChangeInitialState extends HomeState {}

class HomeChangeState extends HomeState {}

class ChangeThemeState extends HomeState {}

class HomeGetAllBranchesLoadingState extends HomeState {}

class HomeGetAllBranchesSuccessState extends HomeState {}

class HomeGetAllBranchesErrorState extends HomeState {
  final String error;

  HomeGetAllBranchesErrorState(this.error);
}

class GetNotificationCountLoadingState extends HomeState {}

class GetNotificationCountSuccessState extends HomeState {}

class GetNotificationCountErrorState extends HomeState {
  String error;

  GetNotificationCountErrorState(this.error);
}

class GetHomeNotificationLoadingState extends HomeState {}

class GetHomeNotificationSuccessState extends HomeState {}

class GetHomeNotificationErrorState extends HomeState {
  String error;

  GetHomeNotificationErrorState(this.error);
}

class GetCategoriesLoadingState extends HomeState {}

class GetCategoriesSuccessState extends HomeState {}

class GetCategoriesErrorState extends HomeState {
  String error;

  GetCategoriesErrorState(this.error);
}

class ReadHomeOneNotificationState extends HomeState {}

class ReadHomeAllNotificationState extends HomeState {}
