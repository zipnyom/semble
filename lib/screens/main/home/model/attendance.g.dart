// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) {
  return Attendance(
    json['class_name'] as String,
    json['student_id'] as String,
    json['time_stamp'] as String,
    json['description'] as String,
    json['confirmer'] as String,
    json['method'] as String,
  );
}

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'class_name': instance.className,
      'student_id': instance.studentId,
      'time_stamp': instance.timeStamp,
      'description': instance.description,
      'confirmer': instance.confirmer,
      'method': instance.method,
    };
