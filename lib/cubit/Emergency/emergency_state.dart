part of 'emergency_cubit.dart';

@immutable
abstract class EmergencyState {}

class EmergencyInitial extends EmergencyState {
  final EmergencyModel? data;
  EmergencyInitial({this.data});
}
class EmergencyLoading extends EmergencyState {}
class EmergencyError extends EmergencyState {
  final String msg;
  EmergencyError({required this.msg});
}
