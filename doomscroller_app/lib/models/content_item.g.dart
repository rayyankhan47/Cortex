// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentItem _$ContentItemFromJson(Map<String, dynamic> json) => ContentItem(
      id: json['id'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      estimatedTimeSeconds: (json['estimatedTimeSeconds'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      likes: (json['likes'] as num).toInt(),
      shares: (json['shares'] as num).toInt(),
      views: (json['views'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: json['author'] as String,
      isInteractive: json['isInteractive'] as bool,
      solution: json['solution'] as String?,
      audioUrl: json['audioUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ContentItemToJson(ContentItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'estimatedTimeSeconds': instance.estimatedTimeSeconds,
      'tags': instance.tags,
      'likes': instance.likes,
      'shares': instance.shares,
      'views': instance.views,
      'createdAt': instance.createdAt.toIso8601String(),
      'author': instance.author,
      'isInteractive': instance.isInteractive,
      'solution': instance.solution,
      'audioUrl': instance.audioUrl,
      'imageUrl': instance.imageUrl,
      'metadata': instance.metadata,
    };

const _$ContentTypeEnumMap = {
  ContentType.chess: 'chess',
  ContentType.math: 'math',
  ContentType.programming: 'programming',
  ContentType.science: 'science',
  ContentType.mindfulness: 'mindfulness',
  ContentType.story: 'story',
  ContentType.podcast: 'podcast',
  ContentType.explainer: 'explainer',
};

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
};
