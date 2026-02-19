class AppConstants {
  // App Info
  static const String appName = 'MFU Eventify';
  static const String appTagline = 'Never miss campus events again';
  static const String appSubtitle = 'For MFU Community Only';
  
  // Navigation Labels
  static const String home = 'Home';
  static const String saved = 'Saved';
  static const String create = 'Create';
  static const String settings = 'Settings';
  
  // Screen Titles
  static const String upcomingEvents = 'Upcoming Events';
  static const String eventDetails = 'Event Details';
  static const String savedEvents = 'Saved Events';
  static const String createEvent = 'Create Event';
  
  // Form Labels
  static const String email = 'Email';
  static const String password = 'Password';
  static const String eventTitle = 'Event Title';
  static const String category = 'Category';
  static const String date = 'Date';
  static const String time = 'Time';
  static const String location = 'Location';
  static const String description = 'Description';
  
  // Button Labels
  static const String getStarted = 'Get Started';
  static const String login = 'Login';
  static const String saveEvent = 'Save Event';
  static const String setReminder = 'Set Reminder';
  static const String createEventButton = 'Create Event';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  
  // Categories
  static const List<String> eventCategories = [
    'Academic',
    'Career',
    'Workshop',
    'Social',
    'Sports',
    'Cultural',
  ];
  
  // Reminder Options
  static const List<Map<String, String>> reminderOptions = [
    {'id': '5min', 'label': '5 min', 'value': '5min'},
    {'id': '15min', 'label': '15 min', 'value': '15min'},
    {'id': '30min', 'label': '30 min', 'value': '30min'},
    {'id': '1hour', 'label': '1 hour', 'value': '1hour'},
    {'id': '3hour', 'label': '3 hours', 'value': '3hour'},
    {'id': '1day', 'label': '1 day', 'value': '1day'},
  ];
  
  // Time Units
  static const List<String> timeUnits = ['Minutes', 'Hours', 'Days'];
  
  // Settings
  static const List<String> reminderTimeOptions = [
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '2 hours before',
    '1 day before',
  ];
}
