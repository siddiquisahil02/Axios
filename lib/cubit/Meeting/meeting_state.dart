part of 'meeting_cubit.dart';

@immutable
abstract class MeetingState {}

class MeetingInitial extends MeetingState {
  final List<MeetingModel> data;
  MeetingInitial({required this.data});
}
class MeetingLoading extends MeetingState {}
class MeetingError extends MeetingState {
  final String msg;
  MeetingError({required this.msg});
}
