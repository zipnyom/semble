// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
    json['clicker_id'] as String,
    json['student_id'] as String,
    json['reponse'] as String,
  );
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'clicker_id': instance.clickerId,
      'student_id': instance.studentId,
      'reponse': instance.resposne,
    };
