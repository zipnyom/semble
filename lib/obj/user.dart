import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends ChangeNotifier {
  final String name;
  final String email;
  @JsonKey(name: "created_time")
  final int createdTime;

  User(this.name, this.email, this.createdTime);

  factory User.fromJSON(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
