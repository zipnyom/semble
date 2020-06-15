import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart';

@JsonSerializable()
class Attendance {
  @JsonKey(name: 'class_name')
  String className;
  @JsonKey(name: 'student_name')
  String studentName;
  @JsonKey(name: 'time_stamp')
  String timeStamp;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'confirmer')
  String confirmer;
  @JsonKey(name: 'method')
  String method;

  bool _checked = false;

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  Attendance(
    this.className,
    this.studentName,
    this.timeStamp,
    this.description,
    this.confirmer,
    this.method,
  );

  

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}
