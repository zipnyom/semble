// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Class _$ClassFromJson(Map<String, dynamic> json) {
  return Class(
    title: json['title'] as String,
    creator: json['creator'] as String,
    managers: (json['managers'] as List)?.map((e) => e as String)?.toList(),
    description: json['description'] as String,
    startDate: json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String),
  )
    ..created = json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String)
    ..type = _$enumDecodeNullable(_$ClassTypeEnumMap, json['type'])
    ..holidays = (json['holidays'] as List)
        ?.map((e) => e == null ? null : DateTime.parse(e as String))
        ?.toList();
}

Map<String, dynamic> _$ClassToJson(Class instance) => <String, dynamic>{
      'title': instance.title,
      'creator': instance.creator,
      'created': instance.created?.toIso8601String(),
      'managers': instance.managers,
      'description': instance.description,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'type': _$ClassTypeEnumMap[instance.type],
      'holidays': instance.holidays?.map((e) => e?.toIso8601String())?.toList(),
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

const _$ClassTypeEnumMap = {
  ClassType.regular: 'regular',
  ClassType.irregular: 'irregular',
};
