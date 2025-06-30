import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import 'reset_password_screen.dart';


class OTPVerificationFPScreen extends StatefulWidget {
  final String username;

  const OTPVerificationFPScreen({Key? key, required this.username}) : super(key: key);
  @override
  State<OTPVerificationFPScreen> createState() => _OTPVerificationFPScreenState();
}

class _OTPVerificationFPScreenState extends State<OTPVerificationFPScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _verifyOTPForgotPassword() async {
    // Check if all 6 digits are filled
    if (_otpCode.length != 6) {
      _showError('Vui lòng nhập đầy đủ 6 số OTP');
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.verifyOTPForgotPassword(widget.username, _otpCode.trim());

        if (!mounted) return;

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(
                username: widget.username,
                otp: _otpCode.trim(),
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

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Xác minh OTP',
            style: AppStyles.headingStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Vui lòng kiểm tra email và nhập mã OTP để tiếp tục',
              textAlign: TextAlign.center,
              style: AppStyles.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Xác minh OTP'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 40),
                Card(
                  elevation: 8,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Nhập mã OTP được gửi tới email của bạn',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF616161),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 50,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),                                    boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1A000000),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                              ),
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.red, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Move to next field
                                    if (index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else {
                                      // Last field, remove focus
                                      _focusNodes[index].unfocus();
                                    }
                                  } else if (value.isEmpty && index > 0) {
                                    // Move to previous field when backspace
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty ? '' : null,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          onPressed: _verifyOTPForgotPassword,
                          text: 'Xác nhận OTP',
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
