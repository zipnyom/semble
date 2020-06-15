import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart';

@JsonSerializable()
class Attendance {
  @JsonKey(name: 'class_name')
  String className;
  @JsonKey(name: 'student_id')
  String studentId;
  @JsonKey(name: 'time_stamp')
  String timeStamp;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'confirmer')
  String confirmer;
  @JsonKey(name: 'method')
  String method;

  Attendance(
    this.className,
    this.studentId,
    this.timeStamp,
    this.description,
    this.confirmer,
    this.method,
  );

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}
