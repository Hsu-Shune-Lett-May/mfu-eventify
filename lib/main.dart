import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_routes.dart';
import 'features/landing/landing_screen.dart';
import 'features/welcome/welcome_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/events/home_screen.dart';
import 'features/events/event_detail_screen.dart';
import 'features/saved_events/saved_events_screen.dart';
import 'features/events/create_event_screen.dart';
import 'features/events/my_events_screen.dart';
import 'features/settings/settings_screen.dart';
import 'models/event_model.dart';
import 'services/firestore_service.dart';
import 'services/hive_service.dart';
import 'services/event_repository.dart';
import 'services/notification_service.dart';
import 'providers/event_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());
  await HiveService.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Create services
  final firestoreService = FirestoreService();
  final hiveService = HiveService();
  final notificationService = NotificationService();
  await notificationService.initialize();

  final eventRepository = EventRepository(
    firestoreService: firestoreService,
    hiveService: hiveService,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => EventProvider(
        repository: eventRepository,
        notificationService: notificationService,
      )..init(),
      child: const MFUEventifyApp(),
    ),
  );
}

class MFUEventifyApp extends StatelessWidget {
  const MFUEventifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFU Eventify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (context) => const LandingScreen(),
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.eventDetail: (context) => const EventDetailScreen(),
        AppRoutes.saved: (context) => const SavedEventsScreen(),
        AppRoutes.create: (context) => const CreateEventScreen(),
        AppRoutes.myEvents: (context) => const MyEventsScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
    );
  }
}