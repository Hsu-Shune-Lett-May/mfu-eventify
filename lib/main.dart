import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_routes.dart';
import 'features/welcome/welcome_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/events/home_screen.dart';
import 'features/events/event_detail_screen.dart';
import 'features/saved_events/saved_events_screen.dart';
import 'features/events/create_event_screen.dart';
import 'features/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MFUEventifyApp());
}

class MFUEventifyApp extends StatelessWidget {
  const MFUEventifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFU Eventify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.eventDetail: (context) => const EventDetailScreen(),
        AppRoutes.saved: (context) => const SavedEventsScreen(),
        AppRoutes.create: (context) => const CreateEventScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
    );
  }
}