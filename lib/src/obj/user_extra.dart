import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_extra.g.dart';

@JsonSerializable()
class UserExtra extends ChangeNotifier {
  String uid;
  String profilePath;

  UserExtra({this.profilePath});

  factory UserExtra.fromJSON(Map<String, dynamic> json) =>
      _$UserExtraFromJson(json);

  Map<String, dynamic> toJson() => _$UserExtraToJson(this);
}
