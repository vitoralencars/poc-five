// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWord _$DailyWordFromJson(Map<String, dynamic> json) => DailyWord(
      dailyWord: json['dailyWord'] as String,
      nextWordRemainingTime: json['nextWordRemainingTime'] as String,
    );

Map<String, dynamic> _$DailyWordToJson(DailyWord instance) => <String, dynamic>{
      'dailyWord': instance.dailyWord,
      'nextWordRemainingTime': instance.nextWordRemainingTime,
    };
