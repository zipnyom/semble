import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vote_item.g.dart';

@JsonSerializable()
class VoteItem {
  String title;
  int count;
  int order;
  List<String> voters;

  @JsonKey(ignore: true)
  DocumentSnapshot doc;

  @JsonKey(ignore: true)
  TextEditingController controller = TextEditingController();

  VoteItem({this.title, this.order, this.count, this.voters});

  factory VoteItem.fromJson(Map<String, dynamic> json) =>
      _$VoteItemFromJson(json);

  Map<String, dynamic> toJson() => _$VoteItemToJson(this);
}
