import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'reset_password_screen.dart';
import '../../../../core/enums/status_code.dart'; // Import StatusCode

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

        switch (response.status) {
          case StatusCode.OK: // Assuming 200 OK for OTP verified
          case StatusCode.OTP_VERIFIED_SUCCESS:
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
          case StatusCode.INVALID_OTP:
            _showError(response.message); // Use message from response
            break;
          // Consider adding a case for OTP_EXPIRED if your API and StatusCode enum support it
          // case StatusCode.OTP_EXPIRED:
          //   _showError(response.message);
          //   break;
          default:
            _showError(response.message); // Show the message from the response
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
