class EventModel {
  final int id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String category;
  final String? description;
  final String? organizer;
  final String? image;
  bool isSaved;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    this.description,
    this.organizer,
    this.image,
    this.isSaved = false,
  });

  EventModel copyWith({
    int? id,
    String? title,
    String? date,
    String? time,
    String? location,
    String? category,
    String? description,
    String? organizer,
    String? image,
    bool? isSaved,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      category: category ?? this.category,
      description: description ?? this.description,
      organizer: organizer ?? this.organizer,
      image: image ?? this.image,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  // Sample data for testing
  static List<EventModel> getSampleEvents() {
    return [
      EventModel(
        id: 1,
        title: 'Computer Science Symposium',
        date: 'Feb 8, 2026',
        time: '9:00 AM - 12:00 PM',
        location: 'Engineering Building, Room 301',
        category: 'Academic',
        description: 'A comprehensive symposium covering the latest trends in computer science.',
        organizer: 'CS Department',
      ),
      EventModel(
        id: 2,
        title: 'Annual Sports Day',
        date: 'Feb 10, 2026',
        time: '8:00 AM - 5:00 PM',
        location: 'University Stadium',
        category: 'Sports',
        description: 'Join us for a day of athletic competitions and fun activities.',
        organizer: 'Sports Club',
      ),
      EventModel(
        id: 3,
        title: 'Career Fair 2026',
        date: 'Feb 12, 2026',
        time: '10:00 AM - 4:00 PM',
        location: 'Student Center Hall',
        category: 'Career',
        description: 'Connect with top employers and explore career opportunities.',
        organizer: 'Career Development Center',
      ),
      EventModel(
        id: 4,
        title: 'Music Club Performance',
        date: 'Feb 15, 2026',
        time: '6:00 PM - 8:00 PM',
        location: 'Auditorium',
        category: 'Cultural',
        description: 'Experience an evening of music performances by talented students.',
        organizer: 'Music Club',
      ),
      EventModel(
        id: 5,
        title: 'Workshop: Web Development',
        date: 'Feb 18, 2026',
        time: '2:00 PM - 5:00 PM',
        location: 'Computer Lab 2',
        category: 'Workshop',
        description: 'Learn modern web development techniques and best practices.',
        organizer: 'Tech Club',
      ),
    ];
  }
}
