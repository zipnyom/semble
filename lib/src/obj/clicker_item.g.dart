// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clicker_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClickerItem _$ClickerItemFromJson(Map<String, dynamic> json) {
  return ClickerItem(
    json['title'] as String,
    json['order'] as int,
    json['count'] as int,
    (json['voters'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ClickerItemToJson(ClickerItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'count': instance.count,
      'order': instance.order,
      'voters': instance.voters,
    };
