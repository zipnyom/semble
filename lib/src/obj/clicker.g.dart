// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clicker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clicker _$ClickerFromJson(Map<String, dynamic> json) {
  return Clicker(
    json['clicker_title'] as String,
    json['time_stamp'] as String,
  )..checked = json['checked'] as bool;
}

Map<String, dynamic> _$ClickerToJson(Clicker instance) => <String, dynamic>{
      'clicker_title': instance.clickerName,
      'time_stamp': instance.timeStamp,
      'checked': instance.checked,
    };
