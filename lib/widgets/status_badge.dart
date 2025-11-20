import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.getStatusColor(status),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppConstants.getStatusIcon(status),
            size: 16,
            color: AppConstants.getStatusColor(status),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: AppConstants.getStatusColor(status),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
