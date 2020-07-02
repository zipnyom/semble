import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schuul/src/data/enums/clicker_type.dart';
import 'package:schuul/src/obj/clicker_item.dart';

part 'clicker.g.dart';

@JsonSerializable()
class Clicker {
  String title;
  DateTime created;
  bool isDate;
  // List<ClickerItem> choices;
  List<ClickerType> options;

  @JsonKey(ignore: true)
  DocumentSnapshot documentSnapshot;

  @JsonKey(ignore: true)
  bool _checked = false;

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  Clicker([
    this.title,
    this.created,
    this.isDate,
    this.options,
  ]);

  factory Clicker.fromJson(Map<String, dynamic> json) =>
      _$ClickerFromJson(json);

  Map<String, dynamic> toJson() => _$ClickerToJson(this);
}
