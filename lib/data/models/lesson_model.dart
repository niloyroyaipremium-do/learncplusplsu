import '../../domain/entities/lesson.dart';

/// Data model for lesson that extends the domain entity
class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.duration,
    required super.difficulty,
    required super.isCompleted,
    required super.content,
    required super.codeExample,
    super.tags,
    super.estimatedTimeMinutes,
    super.category,
    super.order,
    super.metadata,
  });

  /// Creates a LessonModel from JSON
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '5 min',
      difficulty: json['difficulty'] ?? 'Beginner',
      isCompleted: json['isCompleted'] ?? false,
      content: json['content'] ?? '',
      codeExample: json['codeExample'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      estimatedTimeMinutes: json['estimatedTimeMinutes'] ?? 5,
      category: json['category'] ?? 'General',
      order: json['order'] ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  /// Converts LessonModel to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
      'content': content,
      'codeExample': codeExample,
      'tags': tags,
      'estimatedTimeMinutes': estimatedTimeMinutes,
      'category': category,
      'order': order,
      'metadata': metadata,
    };
  }

  /// Creates a LessonModel from a domain Lesson entity
  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      duration: lesson.duration,
      difficulty: lesson.difficulty,
      isCompleted: lesson.isCompleted,
      content: lesson.content,
      codeExample: lesson.codeExample,
      tags: lesson.tags,
      estimatedTimeMinutes: lesson.estimatedTimeMinutes,
      category: lesson.category,
      order: lesson.order,
      metadata: lesson.metadata,
    );
  }

  /// Converts to domain entity
  Lesson toEntity() {
    return Lesson(
      id: id,
      title: title,
      description: description,
      duration: duration,
      difficulty: difficulty,
      isCompleted: isCompleted,
      content: content,
      codeExample: codeExample,
      tags: tags,
      estimatedTimeMinutes: estimatedTimeMinutes,
      category: category,
      order: order,
      metadata: metadata,
    );
  }
}
