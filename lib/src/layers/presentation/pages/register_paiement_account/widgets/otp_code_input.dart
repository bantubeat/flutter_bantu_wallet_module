import 'package:flutter/material.dart';

/// Saisie du code à 6 chiffres (OTP SMS ou e-mail) : 6 cases affichées,
/// pilotées par un champ invisible placé par-dessus.
class OtpCodeInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final int length;

  const OtpCodeInput({
    required this.onChanged,
    super.key,
    this.onCompleted,
    this.length = 6,
  });

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > widget.length) {
      digits.substring(0, widget.length);
    }
    _controller.value = TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
    widget.onChanged(digits);
    if (digits.length == widget.length) {
      widget.onCompleted?.call(digits);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < widget.length; i++)
                _box(
                  char: _controller.text.length > i
                      ? _controller.text[i]
                      : null,
                  active: _focusNode.hasFocus &&
                      _controller.text.length == i,
                ),
            ],
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            autofocus: true,
            maxLength: widget.length,
            onChanged: _onChanged,
            textAlign: TextAlign.center,
            showCursor: false,
            style: const TextStyle(color: Colors.transparent),
            cursorColor: Colors.transparent,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _box({required bool active, String? char}) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 46,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? colorScheme.primary : Colors.transparent,
          width: 1.4,
        ),
      ),
      child: Text(
        char ?? '',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }
}
