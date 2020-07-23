import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class.g.dart';

enum ClassType { regular, irregular }

@JsonSerializable()
class MyClass {
  String title;
  String creatorName;
  String creatorUid;
  DateTime created;
  List<String> managers = [];
  String description;
  DateTime startDate;
  DateTime endDate;
  ClassType type;
  List<int> weekDays = [];
  List<DateTime> days = [];
  List<DateTime> holidays = [];
  int studentCount = 0;
  String imageUrl;
  String creatorImageUrl;
  List<String> members = [];

  @JsonKey(ignore: true)
  String imageLocalPath;
  @JsonKey(ignore: true)
  DocumentSnapshot documentSnapshot;
  @JsonKey(ignore: true)
  TextEditingController titleController = TextEditingController();
  @JsonKey(ignore: true)
  TextEditingController descriptionController = TextEditingController();

  MyClass(
      {this.title,
      this.creatorUid,
      this.managers,
      this.description,
      this.startDate,
      this.endDate});

  factory MyClass.fromJson(Map<String, dynamic> json) =>
      _$MyClassFromJson(json);

  Map<String, dynamic> toJson() => _$MyClassToJson(this);
}
