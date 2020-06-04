// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) {
  return ClassModel(
    name: json['name'] as String,
    start: json['start'] as int,
    end: json['end'] as int,
  );
}

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'start': instance.start,
      'end': instance.end,
    };
