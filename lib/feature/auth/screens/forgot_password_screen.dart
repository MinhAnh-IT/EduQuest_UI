import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import 'otp_verification_screen.dart';
import '../../../core/enums/status_code.dart'; // Import StatusCode

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    print('Starting password reset process');
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
      print('Set loading state to true');
    });

    try {
      print('Calling requestPasswordReset with username: ${_usernameController.text}');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.requestPasswordReset(_usernameController.text);
      print('Got response from API: ${response.status}, ${response.message}');

      if (!mounted) {
        print('Widget not mounted after API call');
        return;
      }

      switch (response.status) {
        case StatusCode.OK: // Assuming 200 OK for OTP sent
          print('API call successful (OTP Sent), navigating to OTP screen');
          setState(() => _otpSent = true);
          break;
        case StatusCode.USER_NOT_FOUND:
          print('API returned user not found');
          _showError(response.message); // Use message from response
          break;
        case StatusCode.EMAIL_SEND_ERROR:
          print('API returned email send failed');
          _showError(response.message); // Use message from response
          break;
        default:
          print('API returned unexpected status: ${response.status.code} - ${response.status.message}');
          _showError(response.message); // Show the message from the response
      }
    } catch (e, stackTrace) {
      print('Error occurred during password reset: $e');
      print('Stack trace: $stackTrace');
      if (!mounted) return;
      _showError('Network error occurred. Please check your connection and try again.');
    } finally {
      print('Cleaning up after password reset attempt');
      if (mounted) {
        setState(() {
          _isLoading = false;
          print('Set loading state to false');
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
        builder: (context) => OTPVerificationScreen(username: _usernameController.text),
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
            text: AppStrings.sendOTP,
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
          Icon(
            Icons.lock_reset_outlined,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            AppStrings.forgotPasswordTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppStrings.enterUsername,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
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
        Text(
          AppStrings.rememberPassword,
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.backToLogin,
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
          text: 'Nhập OTP',
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
      child: Icon(
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
          'OTP Sent!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'An OTP has been sent to verify your username.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
