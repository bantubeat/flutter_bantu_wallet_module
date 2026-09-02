import 'package:flutter/material.dart';

class SuccessResultModal extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onAction;

  const SuccessResultModal({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onAction,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onAction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => SuccessResultModal(
        title: title,
        description: description,
        buttonText: buttonText,
        onAction: onAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResultModalCard(
      icon: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F1F1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Color(0xFF454B54),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      title: title,
      description: description,
      buttonText: buttonText,
      onAction: onAction,
    );
  }
}

class ErrorResultModal extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onAction;

  const ErrorResultModal({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onAction,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onAction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ErrorResultModal(
        title: title,
        description: description,
        buttonText: buttonText,
        onAction: onAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResultModalCard(
      icon: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          color: Color(0xFFFCE9E9),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFE8737A),
          size: 40,
        ),
      ),
      title: title,
      description: description,
      buttonText: buttonText,
      onAction: onAction,
    );
  }
}

class ResultModalCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onAction;
  final Color buttonColor;

  const ResultModalCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onAction,
    // ignore: unused_element_parameter
    this.buttonColor = const Color(0xFF1F2430),
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 22),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14.5,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
