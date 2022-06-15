// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_history_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerHistoryData _$PlayerHistoryDataFromJson(Map<String, dynamic> json) =>
    PlayerHistoryData(
      wins: json['wins'] as int? ?? 0,
      defeats: json['defeats'] as int? ?? 0,
      currentSequence: json['currentSequence'] as int? ?? 0,
      bestSequence: json['bestSequence'] as int? ?? 0,
      attempts:
          (json['attempts'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PlayerHistoryDataToJson(PlayerHistoryData instance) =>
    <String, dynamic>{
      'wins': instance.wins,
      'defeats': instance.defeats,
      'currentSequence': instance.currentSequence,
      'bestSequence': instance.bestSequence,
      'attempts': instance.attempts,
    };
