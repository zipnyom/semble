import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_detail.g.dart';

@JsonSerializable()
class UserDetail extends ChangeNotifier {
  String uid;
  String profilePath;
  List<String> classList = [];

  UserDetail({this.profilePath});

  factory UserDetail.fromJSON(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
