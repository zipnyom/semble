// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_extra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExtra _$UserExtraFromJson(Map<String, dynamic> json) {
  return UserExtra(
    profilePath: json['profilePath'] as String,
  )..uid = json['uid'] as String;
}

Map<String, dynamic> _$UserExtraToJson(UserExtra instance) => <String, dynamic>{
      'uid': instance.uid,
      'profilePath': instance.profilePath,
    };
