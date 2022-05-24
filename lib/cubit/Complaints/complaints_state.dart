part of 'complaints_cubit.dart';

@immutable
abstract class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {
  final List<String> data;
  ComplaintsInitial({required this.data});
}
class ComplaintsLoading extends ComplaintsState {}
class ComplaintsError extends ComplaintsState {
  final String msg;
  ComplaintsError({required this.msg});
}
class ComplaintsDone extends ComplaintsState {}
