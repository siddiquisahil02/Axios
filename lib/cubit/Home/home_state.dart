part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {
  final HomeModel data;
  HomeInitial({required this.data});
}
class HomeLoading extends HomeState {}
class HomeError extends HomeState {
  final String msg;
  HomeError({required this.msg});
}
