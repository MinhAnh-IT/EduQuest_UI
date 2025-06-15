import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'reset_password_screen.dart';


class OTPVerificationFPScreen extends StatefulWidget {
  final String username;

  const OTPVerificationFPScreen({Key? key, required this.username}) : super(key: key);

  @override
  _OTPVerificationFPScreenState createState() => _OTPVerificationFPScreenState();
}

class _OTPVerificationFPScreenState extends State<OTPVerificationFPScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  void _verifyOTPForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.verifyOTPForgotPassword(widget.username, _otpController.text.trim());

        if (!mounted) return;

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(
                username: widget.username,
                otp: _otpController.text.trim(),
              ),
            ),
          );
        } else {
          // Provider đã xử lý lỗi và hiển thị thông báo
          _showError(authProvider.error ?? 'Xác thực OTP thất bại');
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
                onPressed: _isLoading ? null : _verifyOTPForgotPassword,
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
