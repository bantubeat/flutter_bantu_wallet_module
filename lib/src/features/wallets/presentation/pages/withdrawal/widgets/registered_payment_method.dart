import 'package:flutter/material.dart';

class RegisteredPaymentMethod extends StatelessWidget {
  final String type;
  final String number;

  const RegisteredPaymentMethod({
    required this.type,
    required this.number,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                number,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.edit_square,
              size: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
