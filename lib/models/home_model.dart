import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModel {
  HomeModel({
    required this.dues,
    required this.createdAt,
    required this.uid,
    required this.role,
    required this.city,
    required this.fullName,
    required this.houseNo,
    required this.state,
    required this.residence,
    required this.email,
    required this.residenceId,
  });
  late final double dues;
  late final Timestamp createdAt;
  late final String uid;
  late final String role;
  late final String city;
  late final String fullName;
  late final String houseNo;
  late final String state;
  late final String residence;
  late final String email;
  late final String residenceId;

  HomeModel.fromJson(Map<String, dynamic> json){
    dues = json['dues'].toDouble();
    createdAt = json['createdAt'];
    uid = json['uid'];
    role = json['role'];
    city = json['city'];
    fullName = json['fullName'];
    houseNo = json['houseNo'];
    state = json['state'];
    residence = json['residence'];
    email = json['email'];
    residenceId = json['residenceId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dues'] = dues;
    _data['createdAt'] = createdAt;
    _data['uid'] = uid;
    _data['role'] = role;
    _data['city'] = city;
    _data['fullName'] = fullName;
    _data['houseNo'] = houseNo;
    _data['state'] = state;
    _data['residence'] = residence;
    _data['email'] = email;
    _data['residenceId'] = residenceId;
    return _data;
  }
}