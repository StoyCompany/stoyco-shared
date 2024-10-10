/// Represents an onboarding process for a specific feature or area of the application
class Onboarding {
  /// Creates an `Onboarding` object from a JSON map
  ///
  /// * `json`: The JSON map containing the onboarding data
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

  /// Creates an `Onboarding` object
  ///
  /// * `id`: The unique identifier of the onboarding (optional)
  /// * `userId`: The ID of the user associated with the onboarding (optional)
  /// * `type`: The type of onboarding (`OnboardingType`)
  /// * `step`: The current step in the onboarding process
  /// * `isCompleted`: Whether the onboarding is completed
  /// * `createdAt`: The date and time the onboarding was created
  /// * `updatedAt`: The date and time the onboarding was last updated
  Onboarding({
    this.id,
    this.userId,
    required this.type,
    required this.step,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// The unique identifier of the onboarding
  String? id;

  /// The ID of the user associated with the onboarding
  String? userId;

  /// The type of onboarding
  OnboardingType type;

  /// The current step in the onboarding process
  int step;

  /// Whether the onboarding is completed
  bool isCompleted;

  /// The date and time the onboarding was created
  DateTime createdAt;

  /// The date and time the onboarding was last updated
  DateTime updatedAt;

  /// Converts the `Onboarding` object to a JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.toString().split('.').last,
        'step': step,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Returns a string representation of the `Onboarding` object
  @override
  String toString() =>
      'Onboarding{id: $id, userId: $userId, type: $type, step: $step, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt}';
}

/// Represents the different types of onboarding available in the application
enum OnboardingType {
  /// Onboarding for the home screen or main area
  home,

  /// Onboarding for the community section
  community,

  /// Onboarding for the wallet feature
  wallet;

  /// Returns a string representation of the `OnboardingType`
  @override
  String toString() => this == OnboardingType.home
      ? 'home'
      : this == OnboardingType.community
          ? 'community'
          : 'wallet';
}
