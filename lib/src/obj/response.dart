import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class Response {
  @JsonKey(name: 'clicker_id')
   String clickerId;
  @JsonKey(name: 'student_id')
   String studentId;
  @JsonKey(name: 'reponse')
   String resposne;

  Response(this.clickerId, this.studentId, this.resposne
  );

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
