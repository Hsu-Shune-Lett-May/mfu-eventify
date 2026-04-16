import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/buttons/primary_button.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/navigation/app_routes.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  static const String _settingsBox = 'app_settings';
  static const String _termsKey = 'terms_accepted';
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<bool>(_settingsBox);
    final accepted = box.get(_termsKey) ?? false;
    _agreed = accepted;
    if (accepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
    }
  }

  void _handleGetStarted() {
    Hive.box<bool>(_settingsBox).put(_termsKey, true);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'These Terms and Conditions are a placeholder for the MFU Eventify app. '
                        'By continuing, you agree to use the app responsibly and in accordance '
                        'with university policies and applicable laws.\n\n'
                        '1. Eligibility\n'
                        'You must be a member of the MFU community to create and manage events.\n\n'
                        '2. User Content\n'
                        'You are responsible for the events you create and the accuracy of the information.\n\n'
                        '3. Privacy\n'
                        'We store basic profile data (name and email) to personalize your experience.\n\n'
                        '4. Prohibited Use\n'
                        'Do not post offensive, misleading, or unauthorized content.\n\n'
                        '5. Changes\n'
                        'These terms may be updated from time to time.\n\n'
                        'Please read the full terms before continuing.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _agreed,
                      onChanged: (value) {
                        setState(() {
                          _agreed = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'I have read and agree to the Terms & Conditions',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      activeColor: AppColors.primary,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: 'Get Started',
                      onPressed: _agreed ? _handleGetStarted : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
