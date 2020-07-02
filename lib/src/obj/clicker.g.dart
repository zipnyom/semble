// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clicker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clicker _$ClickerFromJson(Map<String, dynamic> json) {
  return Clicker(
    json['title'] as String,
    json['created'] == null ? null : DateTime.parse(json['created'] as String),
    json['isDate'] as bool,
    (json['options'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ClickerTypeEnumMap, e))
        ?.toList(),
  )..checked = json['checked'] as bool;
}

Map<String, dynamic> _$ClickerToJson(Clicker instance) => <String, dynamic>{
      'title': instance.title,
      'created': instance.created?.toIso8601String(),
      'isDate': instance.isDate,
      'options':
          instance.options?.map((e) => _$ClickerTypeEnumMap[e])?.toList(),
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

const _$ClickerTypeEnumMap = {
  ClickerType.complete: 'complete',
  ClickerType.ing: 'ing',
  ClickerType.canceled: 'canceled',
  ClickerType.text: 'text',
  ClickerType.limited: 'limited',
  ClickerType.date: 'date',
  ClickerType.multiple: 'multiple',
  ClickerType.ananymous: 'ananymous',
  ClickerType.addable: 'addable',
};
