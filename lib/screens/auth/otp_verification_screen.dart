import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String username;

  const OTPVerificationScreen({Key? key, required this.username}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final response = await authProvider.verifyOTP(widget.username, _otpController.text.trim());

        if (!mounted) return;

        // API response status is '200' (String) not 'SUCCESS' (String)
        // Convert to string and check for '200' or 'SUCCESS' for flexibility
        final String apiStatus = response.status.toString().toUpperCase();

        switch (apiStatus) {
          case '200': // Check for '200' which is returned by the API
          case 'SUCCESS': // Keep 'SUCCESS' for potential future API changes
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResetPasswordScreen(
                  username: widget.username,
                  otp: _otpController.text.trim(),
                ),
              ),
            );
            break;
          case 'INVALID_OTP':
            _showError('Invalid OTP code');
            break;
          case 'OTP_EXPIRED':
            _showError('OTP has expired');
            break;
          default:
            _showError(response.message);
        }
      } catch (e) {
        if (!mounted) return;
        _showError('Network error occurred');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xác minh OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Nhập mã OTP được gửi tới email của bạn',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'OTP'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập OTP' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
