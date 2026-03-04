import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String time;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final String? organizer;

  @HiveField(8)
  final String? image;

  @HiveField(9)
  bool isSaved;

  @HiveField(10)
  bool isReminderSet;

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
    this.isReminderSet = false,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? location,
    String? category,
    String? description,
    String? organizer,
    String? image,
    bool? isSaved,
    bool? isReminderSet,
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
      isReminderSet: isReminderSet ?? this.isReminderSet,
    );
  }

  /// Convert to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'category': category,
      'description': description,
      'organizer': organizer,
      'image': image,
      'isSaved': isSaved,
      'isReminderSet': isReminderSet,
    };
  }

  /// Create from Firestore document
  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      category: map['category'] ?? '',
      description: map['description'],
      organizer: map['organizer'],
      image: map['image'],
      isSaved: map['isSaved'] ?? false,
      isReminderSet: map['isReminderSet'] ?? false,
    );
  }

  /// Sample data for initial seeding
  static List<EventModel> getSampleEvents() {
    return [
      EventModel(
        id: 'event_1',
        title: 'Computer Science Symposium',
        date: 'Feb 8, 2026',
        time: '9:00 AM - 12:00 PM',
        location: 'Engineering Building, Room 301',
        category: 'Academic',
        description: 'A comprehensive symposium covering the latest trends in computer science.',
        organizer: 'CS Department',
      ),
      EventModel(
        id: 'event_2',
        title: 'Annual Sports Day',
        date: 'Feb 10, 2026',
        time: '8:00 AM - 5:00 PM',
        location: 'University Stadium',
        category: 'Sports',
        description: 'Join us for a day of athletic competitions and fun activities.',
        organizer: 'Sports Club',
      ),
      EventModel(
        id: 'event_3',
        title: 'Career Fair 2026',
        date: 'Feb 12, 2026',
        time: '10:00 AM - 4:00 PM',
        location: 'Student Center Hall',
        category: 'Career',
        description: 'Connect with top employers and explore career opportunities.',
        organizer: 'Career Development Center',
      ),
      EventModel(
        id: 'event_4',
        title: 'Music Club Performance',
        date: 'Feb 15, 2026',
        time: '6:00 PM - 8:00 PM',
        location: 'Auditorium',
        category: 'Cultural',
        description: 'Experience an evening of music performances by talented students.',
        organizer: 'Music Club',
      ),
      EventModel(
        id: 'event_5',
        title: 'Workshop: Web Development',
        date: 'Feb 18, 2026',
        time: '2:00 PM - 5:00 PM',
        location: 'Computer Lab 2',
        category: 'Workshop',
        description: 'Learn modern web development techniques and best practices.',
        organizer: 'Tech Club',
      ),
      EventModel(
        id: 'event_6',
        title: 'AI & Machine Learning Seminar',
        date: 'Mar 5, 2026',
        time: '1:00 PM - 4:00 PM',
        location: 'Science Building, Hall A',
        category: 'Academic',
        description: 'Explore the latest advancements in AI and machine learning with industry experts and hands-on demos.',
        organizer: 'AI Research Lab',
      ),
      EventModel(
        id: 'event_7',
        title: 'International Food Festival',
        date: 'Mar 12, 2026',
        time: '11:00 AM - 7:00 PM',
        location: 'Central Plaza',
        category: 'Social',
        description: 'Taste cuisines from around the world prepared by international student communities.',
        organizer: 'International Student Association',
      ),
      EventModel(
        id: 'event_8',
        title: 'Basketball Tournament',
        date: 'Mar 20, 2026',
        time: '9:00 AM - 6:00 PM',
        location: 'Indoor Sports Complex',
        category: 'Sports',
        description: 'Inter-faculty basketball tournament. Come cheer for your faculty team!',
        organizer: 'MFU Sports Council',
      ),
      EventModel(
        id: 'event_9',
        title: 'Photography Workshop',
        date: 'Mar 25, 2026',
        time: '10:00 AM - 1:00 PM',
        location: 'Art & Design Building, Room 105',
        category: 'Workshop',
        description: 'Learn composition, lighting, and editing techniques from professional photographers.',
        organizer: 'Photography Club',
      ),
      EventModel(
        id: 'event_10',
        title: 'Loy Krathong Night',
        date: 'Apr 2, 2026',
        time: '5:00 PM - 10:00 PM',
        location: 'MFU Lake',
        category: 'Cultural',
        description: 'Celebrate the traditional Thai festival of lights with krathong floating, performances, and food stalls.',
        organizer: 'Student Affairs',
      ),
    ];
  }
}
