import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookticket/models/user_profile.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
      : super(const UserProfile(
          name: 'Flutter DB',
          location: 'New York, USA',
          avatarPath: 'assets/OIP.jpeg',
          miles: 192802,
          milesTarget: 264000,
          tier: 'Gold',
        ));

  void updateProfile(UserProfile profile) {
    state = profile;
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void addMiles(int miles) {
    state = state.copyWith(miles: state.miles + miles);
  }

  void setTier(String tier) {
    state = state.copyWith(tier: tier);
  }
}

final userProfileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
