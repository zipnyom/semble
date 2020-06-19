import 'package:json_annotation/json_annotation.dart';

part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  @JsonKey(name: 'quiz_title')
  String quizName;
  @JsonKey(name: 'time_stamp')
  String timeStamp;

  bool _checked = false;

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  Quiz(
    this.quizName,
    this.timeStamp,
  );

  factory Quiz.fromJson(Map<String, dynamic> json) =>
      _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
