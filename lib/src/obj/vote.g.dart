// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return Vote(
    json['title'] as String,
    json['created'] == null ? null : DateTime.parse(json['created'] as String),
    (json['options'] as List)
        ?.map((e) => _$enumDecodeNullable(_$VoteTypeEnumMap, e))
        ?.toList(),
  )
    ..status = _$enumDecodeNullable(_$VoteTypeEnumMap, json['status'])
    ..checked = json['checked'] as bool;
}

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'title': instance.title,
      'created': instance.created?.toIso8601String(),
      'options': instance.options?.map((e) => _$VoteTypeEnumMap[e])?.toList(),
      'status': _$VoteTypeEnumMap[instance.status],
      'checked': instance.checked,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$VoteTypeEnumMap = {
  VoteType.done: 'done',
  VoteType.running: 'running',
  VoteType.yet: 'yet',
  VoteType.canceled: 'canceled',
  VoteType.text: 'text',
  VoteType.limited: 'limited',
  VoteType.date: 'date',
  VoteType.multiple: 'multiple',
  VoteType.ananymous: 'ananymous',
  VoteType.addable: 'addable',
};
