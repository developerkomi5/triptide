import 'package:flutter/material.dart';

class ItineraryDayCard extends StatelessWidget {
  final int dayNumber;
  final List<String> activities;

  const ItineraryDayCard({
    Key? key,
    required this.dayNumber,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 800,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day badge
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '$dayNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // Header
                Text(
                  'Day $dayNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Divider(height: 10, thickness: 1),

                // Activities list (no limit)
                ...activities.map((activity) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '• $activity',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
