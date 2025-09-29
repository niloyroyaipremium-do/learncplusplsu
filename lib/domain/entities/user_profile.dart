/// Represents a user profile entity in the domain layer
class UserProfile {
  /// Unique identifier for the user
  final String id;

  /// User's display name
  final String name;

  /// User's email address
  final String email;

  /// URL to user's avatar image
  final String? avatar;

  /// User's current level
  final int level;

  /// Total experience points earned
  final int totalXP;

  /// Current streak of consecutive days
  final int currentStreak;

  /// Longest streak achieved
  final int longestStreak;

  /// Number of hearts (lives) remaining
  final int hearts;

  /// Number of lessons completed
  final int lessonsCompleted;

  /// Number of quizzes passed
  final int quizzesPassed;

  /// Last active date
  final DateTime? lastActiveDate;

  /// Whether this is the user's first launch
  final bool isFirstLaunch;

  /// Date when user joined
  final DateTime joinedDate;

  /// Last updated date
  final DateTime? lastUpdatedDate;

  /// Whether user is a guest
  final bool isGuest;

  /// User preferences
  final Map<String, dynamic> preferences;

  /// List of completed lesson IDs
  final List<String> completedLessons;

  /// List of completed quiz IDs
  final List<String> completedQuizzes;

  /// List of user achievements
  final List<String> achievements;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.level,
    required this.totalXP,
    required this.currentStreak,
    required this.longestStreak,
    required this.hearts,
    required this.lessonsCompleted,
    required this.quizzesPassed,
    this.lastActiveDate,
    this.isFirstLaunch = true,
    required this.joinedDate,
    this.lastUpdatedDate,
    this.isGuest = false,
    this.preferences = const {},
    this.completedLessons = const [],
    this.completedQuizzes = const [],
    this.achievements = const [],
  });

  /// Creates a copy of this user profile with the given fields replaced
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? level,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    int? hearts,
    int? lessonsCompleted,
    int? quizzesPassed,
    DateTime? lastActiveDate,
    bool? isFirstLaunch,
    DateTime? joinedDate,
    DateTime? lastUpdatedDate,
    bool? isGuest,
    Map<String, dynamic>? preferences,
    List<String>? completedLessons,
    List<String>? completedQuizzes,
    List<String>? achievements,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      totalXP: totalXP ?? this.totalXP,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      hearts: hearts ?? this.hearts,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      quizzesPassed: quizzesPassed ?? this.quizzesPassed,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      joinedDate: joinedDate ?? this.joinedDate,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      isGuest: isGuest ?? this.isGuest,
      preferences: preferences ?? this.preferences,
      completedLessons: completedLessons ?? this.completedLessons,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      achievements: achievements ?? this.achievements,
    );
  }

  /// Calculates XP needed to reach the next level
  int get xpToNextLevel => (level * 100) - (totalXP % 100);

  /// Gets current level progress (0-100)
  int get currentLevelProgress => totalXP % 100;

  /// Checks if user has full hearts
  bool get hasFullHearts => hearts >= 5;

  /// Checks if current streak is active (within 1 day)
  bool get isStreakActive {
    if (lastActiveDate == null) return false;
    return DateTime.now().difference(lastActiveDate!).inDays <= 1;
  }

  /// Converts to JSON for data persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'level': level,
      'totalXP': totalXP,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'hearts': hearts,
      'lessonsCompleted': lessonsCompleted,
      'quizzesPassed': quizzesPassed,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'isFirstLaunch': isFirstLaunch,
      'joinedDate': joinedDate.toIso8601String(),
      'lastUpdatedDate': lastUpdatedDate?.toIso8601String(),
      'isGuest': isGuest,
      'preferences': preferences,
      'completedLessons': completedLessons,
      'completedQuizzes': completedQuizzes,
      'achievements': achievements,
    };
  }

  /// Creates UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
      level: json['level'] as int? ?? 1,
      totalXP: json['totalXP'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      hearts: json['hearts'] as int? ?? 5,
      lessonsCompleted: json['lessonsCompleted'] as int? ?? 0,
      quizzesPassed: json['quizzesPassed'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'] as String)
          : null,
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'] as String)
          : DateTime.now(),
      lastUpdatedDate: json['lastUpdatedDate'] != null
          ? DateTime.parse(json['lastUpdatedDate'] as String)
          : null,
      isGuest: json['isGuest'] as bool? ?? false,
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      completedLessons:
          (json['completedLessons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      completedQuizzes:
          (json['completedQuizzes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserProfile{id: $id, name: $name, email: $email, level: $level, totalXP: $totalXP}';
  }
}
