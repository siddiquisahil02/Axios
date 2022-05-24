import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  MeetingModel({
    required this.agenda,
    required this.body,
    required this.createdAt,
    required this.uid,
  });
  late final String agenda;
  late final String body;
  late final Timestamp createdAt;
  late final String uid;

  MeetingModel.fromJson(Map<String, dynamic> json){
    agenda = json['agenda'];
    body = json['body'];
    createdAt = json['createdAt'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agenda'] = agenda;
    _data['body'] = body;
    _data['createdAt'] = createdAt;
    _data['uid'] = uid;
    return _data;
  }
}