# Product Requirements Document: MFU Eventify

**Version:** 1.0  
**Last Updated:** February 27, 2026  
**Status:** Active Development  

---

## 1. Executive Summary

MFU Eventify is a mobile application designed to streamline how Mae Fah Luang University (MFU) students discover, track, and participate in campus events. The app centralizes campus event information in one accessible platform and delivers timely reminder notifications to ensure students don't miss important activities.

**One-Sentence Pitch:** Eventify is a mobile app that helps MFU university students keep track of campus events and receive reminders so they don't miss important activities.

---

## 2. Product Overview

### 2.1 Category
Productivity

### 2.2 Platform
Mobile application (iOS and Android supported via Flutter)

### 2.3 Target Institution
Mae Fah Luang University (MFU), Thailand

---

## 3. Problem Statement

### 3.1 Current Challenges
Students at MFU face several obstacles when trying to stay informed about campus events:

- **Information Fragmentation:** Campus events are announced through multiple channels (posters, social media, chat groups, emails), making it difficult to keep track.
- **Information Overload:** Chat groups and social media feeds are noisy, causing important event announcements to get buried.
- **Lack of Persistence:** Social media posts disappear quickly from feeds, and manual calendar entry is time-consuming.
- **Missed Deadlines:** Without a centralized reminder system, students frequently forget event dates and times and miss activities they wanted to attend.
- **Inefficient Discovery:** Calendar applications require manual input and aren't campus-focused, reducing likelihood of engagement.

### 3.2 Why Existing Solutions Fall Short

1. **Social Media (Facebook, Instagram, Line):** Posts become buried quickly; information isn't persistent or easy to search.
2. **Generic Calendar Apps:** Require manual input; not campus-specific; lack event community context.
3. **Chat Groups (Line, Telegram):** Noisy environments; difficult to track specific events; lack structured information presentation.
4. **Email Announcements:** Can be missed; not centralized; lack reminders.

---

## 4. User Personas & Research

### 4.1 Primary Persona: The Busy College Student

**Name:** Busy Bobby  
**Age:** 20 years old  
**Occupation:** University student  
**Location:** MFU Campus  
**Tech Skill Level:** Normal (average smartphone user)  

**Daily Problems:**
- Forgets about upcoming campus events
- Misses interesting activities due to lack of awareness
- Overwhelmed by announcements scattered across multiple platforms

**Goals:**
- Stay informed about campus events
- Never miss activities of interest
- Reduce time spent searching for event information

**Pain Points:**
- Event information scattered across platforms
- No simple reminder system focused on campus activities
- Manual effort required to track events

---

## 5. Solution Overview

### 5.1 Value Proposition

Eventify solves the event discovery and attendance challenge through:

- **Centralized Information:** All campus events in one dedicated app
- **Smart Reminders:** Configurable notifications ensure students never miss events
- **Simple Interface:** Intuitive design makes event discovery effortless
- **Campus-Focused:** Built specifically for MFU community, not a generic solution

### 5.2 How It Solves Each Pain Point

| Pain Point | App Action | Result |
|-----------|-----------|--------|
| Users forget event dates | Save events to personal calendar | Events securely stored and accessible anytime |
| Users miss events they want to attend | Set reminders | Users receive notifications before events start |
| Users overwhelmed by announcements | Centralize all campus events in one app | Reduced confusion and easier event discovery |

---

## 6. Core Features (MVP)

### 6.1 Feature Descriptions

#### 1. **Event List**
- Displays comprehensive list of upcoming campus events
- Shows event title, date, time, location, and thumbnail image
- Sortable and filterable view (by date, category, etc.)
- Chronologically ordered or custom sorting options

#### 2. **Event Details**
- Comprehensive view of individual event information
- Displays: date, time, location description (room, building, campus area)
- Full event description and agenda
- Organizer contact information
- Event category/type identification

#### 3. **Save Event List (Bookmarks)**
- Allow users to bookmark/save events they're interested in
- Personal saved events collection
- View saved events in dedicated section
- Quick access to events earmarked for attendance

#### 4. **Reminder Notifications**
- Send alert notifications before event starts (configurable timing)
- Multiple reminder options (15 min, 30 min, 1 hour, 1 day before)
- Notification delivery via push notifications
- Non-intrusive notification design
- Notification history and management

#### 5. **Create Event**
- Student users can submit/create new events
- Form for entering event title, date, time, location, description
- Category/type selection
- Organizer information
- Event submission (subject to admin approval or direct publish)

---

## 7. User Journeys

### 7.1 Primary User Flow: Discover and Save an Event

```
1. User opens Eventify app
2. Views list of campus events
3. Selects an event of interest
4. Reads event details (date, time, location, description)
5. Clicks "Save Event" button
6. Selects reminder timing preference (15 min, 30 min, 1 hour, 1 day)
7. Event saved to personal calendar with reminder set
8. Receives notification at configured time before event
9. Attends event or marks as attended in app
```

### 7.2 Secondary Flow: Create a New Event

```
1. User opens Eventify app and navigates to "Create Event"
2. Fills in event form (title, date, time, location, description, category)
3. Enters organizer/contact information
4. Submits event
5. Event awaits admin review (or publishes immediately based on permissions)
6. Event appears in community event list
```

### 7.3 Tertiary Flow: View Saved Events

```
1. User opens Eventify app
2. Navigates to "Saved Events" section
3. Views personalized list of bookmarked events
4. Can filter by date or category
5. Selects saved event to view full details
6. Can remove from saved list or manage reminders
```

---

## 8. Success Metrics

### 8.1 Primary Metrics

1. **Daily Active Users (DAU)**
   - Measures how regularly students use the app
   - Indicates app's usefulness for event management
   - Target: Increase DAU weekly by 15% during first semester

2. **Tasks Completed (Events Attended)**
   - Measures students who attended events they saved/set reminders for
   - Direct indication of app's impact on event attendance
   - Target: 60% of saved events result in attendance within first month

### 8.2 Secondary Metrics

- Event list engagement rate
- Reminder notification open rate
- Event creation frequency
- User retention rate (weekly/monthly)
- Average session duration
- Number of events saved per user

---

## 9. Acceptance Criteria

### 9.1 For Event List Feature
- [ ] Display minimum 10 upcoming events
- [ ] Events sorted by date (closest first)
- [ ] Event thumbnail, title, date, and time visible at a glance
- [ ] Touch/click to view full details works smoothly
- [ ] List loads in < 2 seconds

### 9.2 For Event Details Feature
- [ ] All event information (date, time, location, description, organizer) displays correctly
- [ ] Information formatted for readability
- [ ] Images load properly
- [ ] User can return to event list easily

### 9.3 For Save Event Feature
- [ ] User can save/bookmark any event with one tap
- [ ] Saves persist across app sessions
- [ ] Visual indication when event is saved
- [ ] Saved list accessible from main menu

### 9.4 For Reminder Notification Feature
- [ ] Reminders send at scheduled times within 1-minute accuracy
- [ ] [Critical] Notifications deliver reliably (>99% delivery rate)
- [ ] Users can customize reminder timing per event
- [ ] Users can enable/disable reminders globally or per event
- [ ] Reminders work even when app is closed (background notifications)
- [ ] Notification message is clear and includes event name/time

### 9.5 For Create Event Feature
- [ ] Form accepts all required fields (title, date, time, location, description)
- [ ] Form validation prevents incomplete submissions
- [ ] User can upload event image/thumbnail
- [ ] Submission confirmation message displays
- [ ] Event appears in list within reasonable time (subject to admin review if applicable)

---

## 10. Technical Considerations

### 10.1 Key Technical Challenges

**Notification Scheduling [High Priority]:**
- Ensuring notifications appear at the correct time requires careful handling of dates and reminder logic
- Must account for timezone differences if applicable
- Must handle edge cases: app closed, device offline, notification permissions
- Approach: Use platform-specific notification APIs (Firebase Cloud Messaging for Android, Apple Push Notifications for iOS)

### 10.2 Technology Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase or custom API
- **Notifications:** FCM (Firebase Cloud Messaging), Local Notifications
- **Database:** Cloud Firestore or SQL database
- **Authentication:** Firebase Auth or custom auth system

### 10.3 Data Storage

- Event data must be persisted and queryable
- User preferences (saved events, reminder settings) must be securely stored
- Offline functionality should store event data locally for viewing
- Sync mechanism required for data consistency

---

## 11. Out of Scope (Phase 1)

- Social features (sharing, comments, RSVP counts)
- Event location mapping/directions integration
- Advanced analytics and user behavior tracking
- Multi-university support
- Event ticket purchasing/payment integration
- Attendance QR code scanning
- Admin event management dashboard (if delivering user-facing app only)

---

## 12. Timeline & Phases

### Phase 1 (MVP - Current)
Focus on core features: Event List, Event Details, Save Events, Reminders, Create Event

### Phase 2 (Future)
- Event filtering and search improvements
- User profile and preferences
- Social sharing features
- Location mapping

### Phase 3 (Future)
- Admin dashboard for event moderation
- Advanced analytics
- Community features (comments, ratings)

---

## 13. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Notification delivery failures | High | Implement redundant notification systems; extensive testing; fallback mechanisms |
| Low initial adoption | High | Campus marketing; integration with existing channels; incentivize early use |
| Data synchronization issues | Medium | Implement robust sync logic; clear error messages; offline functionality |
| Poor event data quality | Medium | Admin review process; event template/guidelines; validation rules |
| Performance issues at scale | Medium | Database indexing; CDN for assets; load testing before deployment |

---

## 14. Dependencies & Assumptions

### 14.1 Dependencies
- MFU's willingness to promote the app
- Access to authoritative university event calendar/data
- Admin resource for event moderation (if required)
- Push notification service access (Firebase or similar)

### 14.2 Assumptions
- Target users have smartphones with Android or iOS
- Students have internet connectivity at least once daily
- University events follow consistent information structure
- Users will enable notifications to use reminders effectively

---

## 15. Appendix

### 15.1 Glossary
- **DAU:** Daily Active Users
- **MVP:** Minimum Viable Product
- **FCM:** Firebase Cloud Messaging
- **RSVP:** Répondez S'il Vous Plaît (respond if you please)
- **UI/UX:** User Interface/User Experience

### 15.2 References
- Original app concept and evaluation (myapp.md)
- Flutter documentation
- Firebase documentation

---

**Document Approval:** Pending  
**Last Reviewed:** February 27, 2026
