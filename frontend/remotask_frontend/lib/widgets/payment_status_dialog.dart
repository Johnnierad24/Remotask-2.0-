import 'package:flutter/material.dart';

enum PaymentStatus { success, failure, pending }

class PaymentStatusDialog extends StatelessWidget {
  final PaymentStatus status;
  final String title;
  final String message;
  final String? transactionId;
  final VoidCallback? onDismiss;

  const PaymentStatusDialog({
    Key? key,
    required this.status,
    required this.title,
    required this.message,
    this.transactionId,
    this.onDismiss,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required PaymentStatus status,
    required String title,
    required String message,
    String? transactionId,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentStatusDialog(
        status: status,
        title: title,
        message: message,
        transactionId: transactionId,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;

    switch (status) {
      case PaymentStatus.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case PaymentStatus.failure:
        color = Colors.red;
        icon = Icons.error;
        break;
      case PaymentStatus.pending:
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (transactionId != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Transaction ID: $transactionId',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                status == PaymentStatus.success ? 'Done' : 'Close',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
