// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LetterField _$LetterFieldFromJson(Map<String, dynamic> json) => LetterField(
      letter: json['letter'] as String,
      background: json['background'] as int,
      borderColor: json['borderColor'] as int?,
    );

Map<String, dynamic> _$LetterFieldToJson(LetterField instance) =>
    <String, dynamic>{
      'letter': instance.letter,
      'background': instance.background,
      'borderColor': instance.borderColor,
    };
