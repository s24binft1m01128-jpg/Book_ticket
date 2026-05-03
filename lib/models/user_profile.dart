class UserProfile {
  final String name;
  final String location;
  final String avatarPath;
  final int miles;
  final int milesTarget;
  final String tier;

  const UserProfile({
    required this.name,
    required this.location,
    required this.avatarPath,
    required this.miles,
    required this.milesTarget,
    required this.tier,
  });

  UserProfile copyWith({
    String? name,
    String? location,
    String? avatarPath,
    int? miles,
    int? milesTarget,
    String? tier,
  }) {
    return UserProfile(
      name: name ?? this.name,
      location: location ?? this.location,
      avatarPath: avatarPath ?? this.avatarPath,
      miles: miles ?? this.miles,
      milesTarget: milesTarget ?? this.milesTarget,
      tier: tier ?? this.tier,
    );
  }

  double get milesProgress => miles / milesTarget;
  int get milesRemaining => milesTarget - miles;
}
