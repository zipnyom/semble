import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schuul/src/data/enums/vote_type.dart';
import 'package:schuul/src/obj/vote_item.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote {
  String title;
  DateTime created;
  List<VoteType> options = [];
  VoteType status = VoteType.yet;

  @JsonKey(ignore: true)
  DocumentSnapshot documentSnapshot;
  @JsonKey(ignore: true)
  bool _checked = false;
  @JsonKey(ignore: true)
  List<VoteItem> items = List<VoteItem>();
  @JsonKey(ignore: true)
  TextEditingController titleController = TextEditingController();

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  Vote([
    this.title,
    this.created,
    this.options,
  ]);

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);
}
