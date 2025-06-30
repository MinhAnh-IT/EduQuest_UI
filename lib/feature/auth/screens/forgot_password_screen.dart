import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import 'otp_verification_fp_screen.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();  final _usernameController = TextEditingController();
  bool _isLoading = false;
  final bool _otpSent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.requestPasswordReset(_usernameController.text);

      if (!mounted) {
        return;
      }

      if (success) {
        // setState(() => _otpSent = true); // Comment để không hiển thị success screen
        _goToOTPScreen();
      } else {
        _showError(authProvider.error ?? 'Yêu cầu đặt lại mật khẩu thất bại');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Đã xảy ra lỗi mạng. Vui lòng kiểm tra kết nối và thử lại.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _goToOTPScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationFPScreen(username: _usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppStrings.forgotPasswordTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[800],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _otpSent ? _buildOTPSentView() : _buildResetPasswordForm(),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 50),
          CustomTextField(
            controller: _usernameController,
            labelText: 'Tên đăng nhập',
            hintText: 'Nhập tên đăng nhập của bạn',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.text,
            validator: Validators.validateUsername,
          ),
          const SizedBox(height: 30),
          CustomButton(
            onPressed: _isLoading ? null : _resetPassword,
            text: 'Gửi mã OTP',
            isLoading: _isLoading,
          ),
          const SizedBox(height: 30),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.lock_reset_outlined,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            'Quên mật khẩu',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Vui lòng nhập tên đăng nhập để nhận mã OTP đặt lại mật khẩu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã nhớ mật khẩu? ',
          style: TextStyle(color: Color(0xFF757575)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Quay lại đăng nhập',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPSentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        _buildSuccessIcon(),
        const SizedBox(height: 30),
        _buildSuccessMessage(),
        const SizedBox(height: 40),
        CustomButton(
          onPressed: _goToOTPScreen,
          text: 'Nhập mã OTP',
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.sms_outlined,
        size: 60,
        color: Colors.green,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Text(
          'Đã gửi mã OTP!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Mã OTP đã được gửi đến email hoặc số điện thoại của bạn. Vui lòng kiểm tra và nhập mã để tiếp tục.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF757575),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
