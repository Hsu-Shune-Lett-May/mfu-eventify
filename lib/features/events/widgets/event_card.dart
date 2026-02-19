import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import 'event_info_row.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onSaveToggle;
  final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.event,
    required this.onSaveToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCategoryBadge(),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      event.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: event.isSaved ? AppColors.primary : AppColors.iconInactive,
                      size: 20,
                    ),
                    onPressed: onSaveToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Event Details
              EventInfoRow(icon: Icons.calendar_today, text: event.date),
              const SizedBox(height: 8),
              EventInfoRow(icon: Icons.access_time, text: event.time),
              const SizedBox(height: 8),
              EventInfoRow(icon: Icons.location_on, text: event.location),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        event.category,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}