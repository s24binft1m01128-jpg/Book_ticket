import 'package:bookticket/providers/profile_provider.dart';
import 'package:bookticket/providers/payment_provider.dart';
import 'package:bookticket/screen/payment_methods_screen.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/utils/notification_service.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return const _EditProfileSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final defaultPaymentMethod = ref.watch(defaultPaymentMethodProvider);
    final horizontalPadding = AppLayout.horizontalPadding(context);

    return Scaffold(
      backgroundColor: Styles.bgcolor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppLayout.contentWidth(context),
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                28,
              ),
              children: [
                _ProfileHeader(
                  userProfile: userProfile,
                  onEdit: () => _showEditSheet(context, ref),
                ),
                const Gap(22),
                const _AwardCard(),
                const Gap(24),
                _MilesCard(userProfile: userProfile),
                const Gap(24),
                const Text('Account', style: Styles.headlineStyle2),
                const Gap(12),
                _ActionTile(
                  icon: Icons.credit_card_rounded,
                  title: 'Payment methods',
                  subtitle: defaultPaymentMethod != null
                      ? defaultPaymentMethod.maskedCardNumber
                      : 'No payment method added',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodsScreen(),
                      ),
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.group_rounded,
                  title: 'Passengers',
                  subtitle: '1 saved traveler',
                  onTap: () {
                    NotificationService().showInfo(
                      context,
                      'Passenger list feature coming soon',
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.support_agent_rounded,
                  title: 'Support',
                  subtitle: 'Average response under 3 minutes',
                  onTap: () {
                    NotificationService().showInfo(
                      context,
                      'Support chat opened',
                    );
                  },
                ),
                const Gap(10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      NotificationService().showInfo(
                        context,
                        'Book flights and hotels to earn more miles',
                      );
                    },
                    child: const Text('How to get more miles'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int min(int a, int b) => a < b ? a : b;

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet();

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _locationController = TextEditingController(text: profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit profile', style: Styles.headlineStyle2),
          const Gap(16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor: Styles.bgcolor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(12),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Location',
              filled: true,
              fillColor: Styles.bgcolor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(18),
          ElevatedButton(
            onPressed: () {
              ref.read(userProfileProvider.notifier).updateProfile(
                    ref.read(userProfileProvider).copyWith(
                          name: _nameController.text,
                          location: _locationController.text,
                        ),
                  );
              Navigator.pop(context);
              NotificationService().showSuccess(
                context,
                'Profile updated successfully',
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: Styles.primarycolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic userProfile;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.userProfile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            userProfile.avatarPath,
            height: 84,
            width: 84,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userProfile.name,
                style: Styles.headlineStyle2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(4),
              Text(userProfile.location, style: Styles.headlineStyle4),
              const Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Styles.primarycolor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FluentSystemIcons.ic_fluent_shield_filled,
                      color: Styles.primarycolor,
                      size: 16,
                    ),
                    const Gap(6),
                    Text(
                      userProfile.tier,
                      style: Styles.headlineStyle4.copyWith(
                        color: Styles.primarycolor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onEdit,
          child: const Text('Edit'),
        ),
      ],
    );
  }
}

class _AwardCard extends StatelessWidget {
  const _AwardCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Styles.radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF14B8A6), Color(0xFF2F6FED)],
        ),
        boxShadow: Styles.softShadow,
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FluentSystemIcons.ic_fluent_lightbulb_filament_filled,
              color: Styles.primarycolor,
              size: 28,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New achievement unlocked',
                  style: Styles.headlineStyle3.copyWith(color: Colors.white),
                ),
                const Gap(4),
                Text(
                  'You completed 95 flights this year.',
                  style: Styles.headlineStyle4.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MilesCard extends StatelessWidget {
  final dynamic userProfile;

  const _MilesCard({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Styles.radius),
        boxShadow: Styles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Accumulated miles', style: Styles.headlineStyle2),
          const Gap(14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${userProfile.miles}',
                style: Styles.headlineStyle1.copyWith(fontSize: 40),
              ),
              const Gap(8),
              const Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Text('miles', style: Styles.headlineStyle4),
              ),
            ],
          ),
          const Gap(16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: userProfile.milesProgress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Styles.lineColor,
              color: Styles.primarycolor,
            ),
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(userProfile.milesProgress * 100).toStringAsFixed(0)}% to ${userProfile.tier}',
                style: Styles.headlineStyle4,
              ),
              Text(
                'Target: ${userProfile.milesTarget}',
                style: Styles.headlineStyle4,
              ),
            ],
          ),
          const Gap(18),
          const Divider(color: Styles.lineColor),
          const Gap(6),
          const _MilesRow(
            miles: '23,042',
            source: 'Airline CO',
          ),
          const _MilesRow(
            miles: '24',
            source: "McDonald's",
          ),
          _MilesRow(
            miles: '${userProfile.miles - 23066}',
            source: 'Other',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _MilesRow extends StatelessWidget {
  final String miles;
  final String source;
  final bool showDivider;

  const _MilesRow({
    required this.miles,
    required this.source,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(miles, style: Styles.headlineStyle3),
                    const Gap(4),
                    const Text('Miles', style: Styles.headlineStyle4),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(source, style: Styles.headlineStyle3),
                  const Gap(4),
                  const Text('Received from', style: Styles.headlineStyle4),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(color: Styles.lineColor),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Styles.lineColor),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Styles.primarycolor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Styles.primarycolor),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Styles.headlineStyle3),
                      const Gap(4),
                      Text(
                        subtitle,
                        style: Styles.headlineStyle4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Styles.mutedTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
