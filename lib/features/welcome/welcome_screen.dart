import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common/app_logo.dart';
import '../../core/widgets/buttons/primary_button.dart';
import '../../core/navigation/app_routes.dart';
import 'widgets/feature_icon.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(size: 128),
                  const SizedBox(height: 40),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 64),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FeatureIcon(icon: Icons.calendar_today, label: 'Events'),
                      SizedBox(width: 32),
                      FeatureIcon(icon: Icons.notifications_outlined, label: 'Reminders'),
                      SizedBox(width: 32),
                      FeatureIcon(icon: Icons.people_outline, label: 'Community'),
                    ],
                  ),
                  const SizedBox(height: 64),
                  PrimaryButton(
                    text: AppConstants.getStarted,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Join thousands of MFU students',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textItalic,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}