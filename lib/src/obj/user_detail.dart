import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_detail.g.dart';

@JsonSerializable()
class UserDetail extends ChangeNotifier {
  final String profilePath;
  final List<dynamic> classList;
  final List<dynamic> requestList;
  @JsonKey(ignore: true)
  DocumentSnapshot documentSnapshot;

  UserDetail({this.profilePath, classList, requestList})
      : classList = classList ?? [],
        requestList = requestList ?? [];

  factory UserDetail.fromJSON(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
