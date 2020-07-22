import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_detail.g.dart';

@JsonSerializable()
class UserDetail extends ChangeNotifier {
  String profilePath;
  List<String> classList = [];
  List<String> requestList = [];
  @JsonKey(ignore: true)
  DocumentSnapshot documentSnapshot;

  UserDetail();

  factory UserDetail.fromJSON(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
