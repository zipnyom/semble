import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class.g.dart';

enum ClassType { regular, irregular }

@JsonSerializable()
class Class {
  String title;
  String creator;
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

  @JsonKey(ignore: true)
  DocumentSnapshot documentSnapshot;
  @JsonKey(ignore: true)
  TextEditingController titleController = TextEditingController();

  Class(
      {this.title,
      this.creator,
      this.managers,
      this.description,
      this.startDate,
      this.endDate});

  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

  Map<String, dynamic> toJson() => _$ClassToJson(this);
}
