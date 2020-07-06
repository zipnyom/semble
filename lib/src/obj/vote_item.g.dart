// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteItem _$VoteItemFromJson(Map<String, dynamic> json) {
  return VoteItem(
    title: json['title'] as String,
    order: json['order'] as int,
    count: json['count'] as int,
    voters: (json['voters'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$VoteItemToJson(VoteItem instance) => <String, dynamic>{
      'title': instance.title,
      'count': instance.count,
      'order': instance.order,
      'voters': instance.voters,
    };
