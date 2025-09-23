import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PaymentAccountPhoneField extends StatelessWidget {
  final String label;
  final PhoneNumber? initialValue;
  final void Function(PhoneNumber)? onInputChanged;
  final void Function(bool)? onInputValidated;

  const PaymentAccountPhoneField({
    required this.label,
    required this.onInputChanged,
    this.onInputValidated,
    this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initialPhoneValue =
        initialValue != null && initialValue != PhoneNumber()
            ? initialValue
            : PhoneNumber(isoCode: 'CM');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        InternationalPhoneNumberInput(
          onInputChanged: onInputChanged,
          onInputValidated: onInputValidated,
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            setSelectorButtonAsPrefixIcon: true,
            leadingPadding: 8,
            trailingSpace: false,
          ),
          initialValue: initialPhoneValue,
          spaceBetweenSelectorAndTextField: 5,
          autoValidateMode: AutovalidateMode.always,
          inputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
