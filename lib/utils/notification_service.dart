import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  void showSuccess(BuildContext context, String message) {
    _showNotification(context, message, Colors.green, Icons.check_circle);
  }

  void showError(BuildContext context, String message) {
    _showNotification(context, message, Colors.red, Icons.error);
  }

  void showInfo(BuildContext context, String message) {
    _showNotification(context, message, Colors.blue, Icons.info);
  }

  void showWarning(BuildContext context, String message) {
    _showNotification(context, message, Colors.orange, Icons.warning);
  }

  void _showNotification(
      BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
