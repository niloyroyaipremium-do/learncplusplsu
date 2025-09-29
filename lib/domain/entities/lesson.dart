/// Represents a lesson entity in the domain layer
class Lesson {
  /// Unique identifier for the lesson
  final String id;

  /// Title of the lesson
  final String title;

  /// Description of what the lesson covers
  final String description;

  /// Estimated duration to complete the lesson
  final String duration;

  /// Difficulty level of the lesson
  final String difficulty;

  /// Whether the lesson has been completed
  final bool isCompleted;

  /// Main content of the lesson
  final String content;

  /// Code example for the lesson
  final String codeExample;

  /// Tags associated with the lesson
  final List<String> tags;

  /// Estimated time in minutes
  final int estimatedTimeMinutes;

  /// Category the lesson belongs to
  final String category;

  /// Order of the lesson in the sequence
  final int order;

  /// Additional metadata for the lesson
  final Map<String, dynamic> metadata;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.isCompleted,
    required this.content,
    required this.codeExample,
    this.tags = const [],
    this.estimatedTimeMinutes = 5,
    this.category = 'General',
    this.order = 0,
    this.metadata = const {},
  });

  /// Creates a copy of this lesson with the given fields replaced
  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? duration,
    String? difficulty,
    bool? isCompleted,
    String? content,
    String? codeExample,
    List<String>? tags,
    int? estimatedTimeMinutes,
    String? category,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
      codeExample: codeExample ?? this.codeExample,
      tags: tags ?? this.tags,
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
      category: category ?? this.category,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts to JSON for data persistence
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

  /// Creates Lesson from JSON
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      duration: json['duration'] as String? ?? '5 min',
      difficulty: json['difficulty'] as String? ?? 'Beginner',
      isCompleted: json['isCompleted'] as bool? ?? false,
      content: json['content'] as String? ?? '',
      codeExample: json['codeExample'] as String? ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int? ?? 5,
      category: json['category'] as String? ?? 'General',
      order: json['order'] as int? ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Lesson{id: $id, title: $title, difficulty: $difficulty, isCompleted: $isCompleted}';
  }
}
