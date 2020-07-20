// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) {
  return UserDetail(
    profilePath: json['profilePath'] as String,
  )
    ..uid = json['uid'] as String
    ..classList =
        (json['classList'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'profilePath': instance.profilePath,
      'classList': instance.classList,
    };
