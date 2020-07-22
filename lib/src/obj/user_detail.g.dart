// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) {
  return UserDetail()
    ..profilePath = json['profilePath'] as String
    ..classList = (json['classList'] as List)?.map((e) => e as String)?.toList()
    ..requestList =
        (json['requestList'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'profilePath': instance.profilePath,
      'classList': instance.classList,
      'requestList': instance.requestList,
    };
