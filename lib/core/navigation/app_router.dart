import 'package:flutter/material.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/events/home_screen.dart';
import '../../features/events/event_detail_screen.dart';
import '../../features/saved_events/saved_events_screen.dart';
import '../../features/events/create_event_screen.dart';
import '../../features/settings/settings_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case AppRoutes.eventDetail:
        return MaterialPageRoute(builder: (_) => const EventDetailScreen());
      
      case AppRoutes.saved:
        return MaterialPageRoute(builder: (_) => const SavedEventsScreen());
      
      case AppRoutes.create:
        return MaterialPageRoute(builder: (_) => const CreateEventScreen());
      
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
