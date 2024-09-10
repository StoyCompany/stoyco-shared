class Onboarding {
  factory Onboarding.fromJson(Map<String, dynamic> json) => Onboarding(
        id: json['id'],
        userId: json['userId'],
        type: json['type'] == 'home'
            ? OnboardingType.home
            : json['type'] == 'community'
                ? OnboardingType.community
                : OnboardingType.wallet,
        step: json['step'],
        isCompleted: json['isCompleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
  Onboarding({
    this.id,
    this.userId,
    required this.type,
    required this.step,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  String? id;
  String? userId;
  OnboardingType type;
  int step;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.toString().split('.').last,
        'step': step,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  @override
  String toString() =>
      'Onboarding{id: $id, userId: $userId, type: $type, step: $step, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt}';
}

enum OnboardingType {
  home,
  community,
  wallet;

  @override
  String toString() => this == OnboardingType.home
      ? 'home'
      : this == OnboardingType.community
          ? 'community'
          : 'wallet';
}
