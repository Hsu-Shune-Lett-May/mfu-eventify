import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:mfu_eventify/services/hive_service.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/cards/base_card.dart';
import '../../core/navigation/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../events/widgets/bottom_nav_bar.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_switch_item.dart';
import 'widgets/settings_menu_item.dart';
import 'package:mfu_eventify/providers/auth_provider.dart' hide AuthProvider;
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedTab = 3;
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool eventReminders = true;
  String defaultReminderTime = '1 hour before';

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });

    switch (index) {
      case 0:
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.saved);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.create);
        break;
      case 3:
        // Already on settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserProfile(),
                      const SizedBox(height: 12),
                      _buildNotificationsSection(),
                      const SizedBox(height: 12),
                      _buildPreferencesSection(),
                      const SizedBox(height: 12),
                      _buildAboutSection(),
                      const SizedBox(height: 12),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            const Text(
              AppConstants.settings,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
  // Try Hive cache first (works offline), then Firebase Auth
  final hiveUser = HiveService().getUser();
  final firebaseUser = FirebaseAuth.instance.currentUser;

  final displayName = hiveUser?.name
      ?? firebaseUser?.displayName
      ?? 'MFU Student';
  final email = hiveUser?.email
      ?? firebaseUser?.email
      ?? '';

  final parts = displayName.trim().split(' ');
  final initials = parts.length >= 2
      ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
      : displayName.substring(0, displayName.length >= 2 ? 2 : 1).toUpperCase();


    return BaseCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return SettingsSection(
      title: 'Notifications',
      children: [
        SettingsSwitchItem(
          icon: Icons.notifications_outlined,
          title: 'Push Notifications',
          value: pushNotifications,
          onChanged: (val) => setState(() => pushNotifications = val),
          showDivider: true,
        ),
        SettingsSwitchItem(
          icon: Icons.email_outlined,
          title: 'Email Notifications',
          value: emailNotifications,
          onChanged: (val) => setState(() => emailNotifications = val),
          showDivider: true,
        ),
        SettingsSwitchItem(
          icon: Icons.alarm,
          title: 'Event Reminders',
          value: eventReminders,
          onChanged: (val) => setState(() => eventReminders = val),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        BaseCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundGradientEnd,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Default Reminder Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: defaultReminderTime,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                items: AppConstants.reminderTimeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    defaultReminderTime = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSection(
      title: 'About',
      children: [
        SettingsMenuItem(
          icon: Icons.info_outline,
          title: 'About MFU Eventify',
          onTap: () {},
          showDivider: true,
        ),
        SettingsMenuItem(
          icon: null,
          title: 'Terms & Conditions',
          onTap: () {},
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return BaseCard(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext); // close dialog first
                  await context.read<AuthProvider>().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.landing,
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.backgroundGradientEnd,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout,
              size: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Logout',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}