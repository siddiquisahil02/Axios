part of 'permission_cubit.dart';

@immutable
abstract class PermissionState {}

class PermissionInitial extends PermissionState {
  final Map<String,dynamic>? data;
  PermissionInitial({required this.data});
}
class PermissionLoading extends PermissionState {}
class PermissionDone extends PermissionState {}
class PermissionError extends PermissionState {
  final String msg;
  PermissionError({required this.msg});
}
