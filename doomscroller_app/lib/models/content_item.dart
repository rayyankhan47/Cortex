import 'package:json_annotation/json_annotation.dart';

part 'content_item.g.dart';

enum ContentType {
  chess,
  math,
  programming,
  science,
  mindfulness,
  story,
  podcast,
  explainer,
}

enum Difficulty {
  easy,
  medium,
  hard,
}

@JsonSerializable()
class ContentItem {
  final String id;
  final ContentType type;
  final String title;
  final String description;
  final String content;
  final Difficulty difficulty;
  final int estimatedTimeSeconds;
  final List<String> tags;
  final int likes;
  final int shares;
  final int views;
  final DateTime createdAt;
  final String author;
  final bool isInteractive;
  final String? solution;
  final String? audioUrl;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const ContentItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.content,
    required this.difficulty,
    required this.estimatedTimeSeconds,
    required this.tags,
    required this.likes,
    required this.shares,
    required this.views,
    required this.createdAt,
    required this.author,
    required this.isInteractive,
    this.solution,
    this.audioUrl,
    this.imageUrl,
    this.metadata,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) => _$ContentItemFromJson(json);
  Map<String, dynamic> toJson() => _$ContentItemToJson(this);

  String get categoryIcon {
    switch (type) {
      case ContentType.chess:
        return '♟️';
      case ContentType.math:
        return '🧮';
      case ContentType.programming:
        return '💻';
      case ContentType.science:
        return '🔬';
      case ContentType.mindfulness:
        return '🧘';
      case ContentType.story:
        return '📖';
      case ContentType.podcast:
        return '🎧';
      case ContentType.explainer:
        return '📈';
    }
  }

  String get categoryName {
    switch (type) {
      case ContentType.chess:
        return 'Chess Puzzle';
      case ContentType.math:
        return 'Math Brainteaser';
      case ContentType.programming:
        return 'CS Trivia';
      case ContentType.science:
        return 'Science Fact';
      case ContentType.mindfulness:
        return 'Mindfulness';
      case ContentType.story:
        return 'Interactive Story';
      case ContentType.podcast:
        return 'Podcast Snippet';
      case ContentType.explainer:
        return 'Topic Explainer';
    }
  }

  String get difficultyText {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  String get formattedTime {
    final minutes = estimatedTimeSeconds ~/ 60;
    final seconds = estimatedTimeSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  ContentItem copyWith({
    String? id,
    ContentType? type,
    String? title,
    String? description,
    String? content,
    Difficulty? difficulty,
    int? estimatedTimeSeconds,
    List<String>? tags,
    int? likes,
    int? shares,
    int? views,
    DateTime? createdAt,
    String? author,
    bool? isInteractive,
    String? solution,
    String? audioUrl,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return ContentItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      difficulty: difficulty ?? this.difficulty,
      estimatedTimeSeconds: estimatedTimeSeconds ?? this.estimatedTimeSeconds,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      isInteractive: isInteractive ?? this.isInteractive,
      solution: solution ?? this.solution,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
} 