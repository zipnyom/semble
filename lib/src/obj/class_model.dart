import 'package:json_annotation/json_annotation.dart';

part 'class_model.g.dart';

@JsonSerializable()
class ClassModel {
  @JsonKey(name: 'class_name')
  String className;
  @JsonKey(name: 'manager_id')
  String managerId;
  @JsonKey(name: 'sub_manager_id')
  String subManagerId;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'start_date')
  String startDate;
  @JsonKey(name: 'end_date')
  String endDate;

  ClassModel(this.className, this.managerId, this.subManagerId,
      this.description, this.startDate, this.endDate);

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
  
}
