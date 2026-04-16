import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/navigation/app_routes.dart';
import '../../providers/event_provider.dart';
import '../events/widgets/bottom_nav_bar.dart';
import 'widgets/saved_event_card.dart';

class SavedEventsScreen extends StatefulWidget {
  const SavedEventsScreen({Key? key}) : super(key: key);

  @override
  State<SavedEventsScreen> createState() => _SavedEventsScreenState();
}

class _SavedEventsScreenState extends State<SavedEventsScreen> {
  int _selectedTab = 1;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });

    switch (index) {
      case 0:
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.create);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.settings);
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
                child: Consumer<EventProvider>(
                  builder: (context, provider, child) {
                    final savedEvents = provider.savedEvents;

                    if (savedEvents.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: savedEvents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SavedEventCard(
                            event: savedEvents[index],
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.eventDetail,
                                arguments: savedEvents[index],
                              );
                            },
                            onDelete: () {
                              provider.toggleSaveEvent(savedEvents[index].id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('"${savedEvents[index].title}" removed from saved'),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: _selectedTab,
      //   onTabSelected: _onTabSelected,
      // ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // IconButton(
            //   icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            //   onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home)),
            //   padding: EdgeInsets.zero,
            //   constraints: const BoxConstraints(),
            // ),
            const SizedBox(width: 16),
            const Text(
              AppConstants.savedEvents,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_outline,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Saved Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Start bookmarking events to see them here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

