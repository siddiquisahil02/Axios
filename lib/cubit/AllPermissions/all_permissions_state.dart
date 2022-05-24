part of 'all_permissions_cubit.dart';

@immutable
abstract class AllPermissionsState {}

class AllPermissionsInitial extends AllPermissionsState {}
class AllPermissionsLoading extends AllPermissionsState {}
class AllPermissionsError extends AllPermissionsState {
  final String msg;
  AllPermissionsError({required this.msg});
}
class AllPermissionsSuccess extends AllPermissionsState {}
