import 'package:json_annotation/json_annotation.dart';

part 'class_model.g.dart';

@JsonSerializable()
class ClassModel {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'start')
  int start;

  @JsonKey(name: 'end')
  int end;

  ClassModel({String name, int start, int end}) {
    this.name = name;
    this.start = start;
    this.end = end;
  }
}
