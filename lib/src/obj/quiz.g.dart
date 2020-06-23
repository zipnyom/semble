// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return Quiz(
    json['quiz_title'] as String,
    json['time_stamp'] as String,
  )..checked = json['checked'] as bool;
}

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'quiz_title': instance.quizName,
      'time_stamp': instance.timeStamp,
      'checked': instance.checked,
    };
