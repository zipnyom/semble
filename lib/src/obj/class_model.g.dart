// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) {
  return ClassModel(
    json['class_name'] as String,
    json['manager_id'] as String,
    json['sub_manager_id'] as String,
    json['description'] as String,
    json['start_date'] as String,
    json['end_date'] as String,
  );
}

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'class_name': instance.className,
      'manager_id': instance.managerId,
      'sub_manager_id': instance.subManagerId,
      'description': instance.description,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };
