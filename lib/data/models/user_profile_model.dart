import '../../domain/entities/user_profile.dart';

/// Data model for user profile that extends the domain entity
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    required super.level,
    required super.totalXP,
    required super.currentStreak,
    required super.longestStreak,
    required super.hearts,
    required super.lessonsCompleted,
    required super.quizzesPassed,
    super.lastActiveDate,
    super.isFirstLaunch,
    required super.joinedDate,
    super.lastUpdatedDate,
    super.isGuest,
    super.preferences,
    super.completedLessons,
    super.completedQuizzes,
    super.achievements,
  });

  /// Creates a UserProfileModel from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
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

  /// Converts UserProfileModel to JSON
  @override
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

  /// Creates a UserProfileModel from a domain UserProfile entity
  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      avatar: profile.avatar,
      level: profile.level,
      totalXP: profile.totalXP,
      currentStreak: profile.currentStreak,
      longestStreak: profile.longestStreak,
      hearts: profile.hearts,
      lessonsCompleted: profile.lessonsCompleted,
      quizzesPassed: profile.quizzesPassed,
      lastActiveDate: profile.lastActiveDate,
      isFirstLaunch: profile.isFirstLaunch,
      joinedDate: profile.joinedDate,
      lastUpdatedDate: profile.lastUpdatedDate,
      isGuest: profile.isGuest,
      preferences: profile.preferences,
      completedLessons: profile.completedLessons,
      completedQuizzes: profile.completedQuizzes,
      achievements: profile.achievements,
    );
  }

  /// Converts to domain entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      level: level,
      totalXP: totalXP,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      hearts: hearts,
      lessonsCompleted: lessonsCompleted,
      quizzesPassed: quizzesPassed,
      lastActiveDate: lastActiveDate,
      isFirstLaunch: isFirstLaunch,
      joinedDate: joinedDate,
      lastUpdatedDate: lastUpdatedDate,
      isGuest: isGuest,
      preferences: preferences,
      completedLessons: completedLessons,
      completedQuizzes: completedQuizzes,
      achievements: achievements,
    );
  }
}
