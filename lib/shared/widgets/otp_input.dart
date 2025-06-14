import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_login/shared/theme/app_theme.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onCompleted;

  const OtpInput({
    super.key,
    required this.controller,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        letterSpacing: 8,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: '000000',
        hintStyle: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 24,
          letterSpacing: 8,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        if (value.length == 6 && onCompleted != null) {
          onCompleted!(value);
        }
      },
    );
  }
} 